using BinaryProvider # requires BinaryProvider 0.3.0 or later

# Parse some basic command-line arguments
const verbose = "--verbose" in ARGS
const prefix = Prefix(get([a for a in ARGS if a != "--verbose"], 1, joinpath(@__DIR__, "usr")))
products = [
    LibraryProduct(prefix, ["softposit"], :SoftPositPath),
]

# Download binaries from hosted location
bin_prefix = "https://github.com/giordano/SoftPositBuilder/releases/download/v0.4.1"

# Listing of files generated by BinaryBuilder:
download_info = Dict(
    MacOS(:x86_64) => ("$bin_prefix/SoftPosit.v0.4.1.x86_64-apple-darwin14.tar.gz", "d935095c3070f5de3fac047a81984900efd13ec1fcc6a8295bc4470a95283484"),
    Linux(:x86_64, libc=:glibc) => ("$bin_prefix/SoftPosit.v0.4.1.x86_64-linux-gnu.tar.gz", "28e912be49014e086f27a3c86b9b13ac19bedcc11f541bd0e4e91c7b1c2b69d8"),
    FreeBSD(:x86_64) => ("$bin_prefix/SoftPosit.v0.4.1.x86_64-unknown-freebsd11.1.tar.gz", "6f51fda14b2e05c4cdf9efdfec9520f2ce34ab97e962fb8371e7a4111dbb9af4"),
    Windows(:x86_64) => ("$bin_prefix/SoftPosit.v0.4.1.x86_64-w64-mingw32.tar.gz", "706176354e29aec16c4107dc9b779c6039156641f076cabbaf154bc4e6c49398"),
)

# Install unsatisfied or updated dependencies:
unsatisfied = any(!satisfied(p; verbose=verbose) for p in products)
dl_info = choose_download(download_info, platform_key_abi())
if dl_info === nothing && unsatisfied
    # If we don't have a compatible .tar.gz to download, complain.
    # Alternatively, you could attempt to install from a separate provider,
    # build from source or something even more ambitious here.
    error("Your platform (\"$(Sys.MACHINE)\", parsed as \"$(triplet(platform_key_abi()))\") is not supported by this package!")
end

# If we have a download, and we are unsatisfied (or the version we're
# trying to install is not itself installed) then load it up!
if unsatisfied || !isinstalled(dl_info...; prefix=prefix)
    # Download and install binaries
    install(dl_info...; prefix=prefix, force=true, verbose=verbose)
end

# Write out a deps.jl file that will contain mappings for our products
write_deps_file(joinpath(@__DIR__, "deps.jl"), products, verbose=verbose)
