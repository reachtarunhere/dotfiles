using Revise
using OhMyREPL

import REPL
import REPL.LineEdit

const mykeys = Dict{Any,Any}(
    "\ei" => (s, o...)->LineEdit.edit_insert_newline(s)
)

function customize_keys(repl)
    repl.interface = REPL.setup_interface(repl; extra_repl_keymap = mykeys)
end

atreplinit(customize_keys)

push!(LOAD_PATH, "/home/tarun/Projects")

