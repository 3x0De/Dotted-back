require "hashids"


def hash_url(id)
    hashids = Hashids.new ENV["HASH_URL"], 6
    hashids.encode id
end

def unhash_url(val)
    hashids = Hashids.new ENV["HASH_URL"], 6
    hashids.decode val
end