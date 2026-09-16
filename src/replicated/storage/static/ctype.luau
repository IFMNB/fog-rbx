--!strict

export type metainfo = {
    read tag: string,
    read classname: string,
    
}

export type ctype = {
    read write: (self: ctype, of: {[any]: any}, metainfo) -> (),
    read read: (self: ctype, of: {[any]: any}) -> metainfo,

    read generate_metainfo: (self: ctype) -> metainfo
}