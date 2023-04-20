; highlight sql within strings assigned to vars matching:
; `sql = "select * from table"`
; `foo_sql = "select * from table"`
; `sql_foo = "select * from table"`
; @_var is a custom capture that is used to match the variable name
; @sql is a built-in capture that assigns the string to the @sql type
(expression_statement
  (assignment
    left: (identifier) @_var (#match? @_var "[_]?sql[_]?") 
    right: (string) @sql))
; highlight regex within strings given to calls to re module fns
; stolen from https://github.com/as7cheng/dotfiles/blob/00fbc2bff28e5079398d0e594068300378d7798d/.config/nvim/init.vim#L571
((call
  function: (attribute object: (identifier) @_re)
  arguments: (argument_list (string) @regex))
 (#eq? @_re "re")
 (#match? @regex "^r.*"))
; highlight json within strings assigned to vars like, %json%
(expression_statement
  (assignment
    left: (identifier) @_var (#match? @_var "([\w_]*(json)[\w_]*)") 
    right: (string) @json))
