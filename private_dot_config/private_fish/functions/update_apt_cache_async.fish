function update_apt_cache_async \
        --description 'Refresh the APT counter asynchronously'

    __update_package_cache_async apt 10
end
