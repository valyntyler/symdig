#!/usr/bin/env nu

def sym-path []: string -> string {
  ^whereis $in
  | split row ' '
  | last
}

def recurse []: string -> string {
  let path = $in
  let type = $path | path type

  if $type == symlink {
    readlink $path | recurse
  } else {
    $path
  }
}

def main [] {
  "blender" | sym-path | recurse
}
