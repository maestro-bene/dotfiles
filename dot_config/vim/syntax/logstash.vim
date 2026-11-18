" Vim syntax file for Logstash configuration files
if exists("b:current_syntax")
  finish
endif

syn match logstashComment "#.*$"
syn match logstashOperator "[{}|\[\]]"
syn match logstashString "\"[^\"]*\"" 
syn match logstashString "'[^']*'"
syn keyword logstashKeyword input filter output if else mutate grok
syn keyword logstashPlugin grok mutate date json csv kv
syn keyword logstashPlugin elasticsearch opensearch file stdout stdin
syn keyword logstashPlugin beats tcp udp syslog

hi def link logstashComment Comment
hi def link logstashOperator Operator
hi def link logstashString String
hi def link logstashKeyword Keyword
hi def link logstashPlugin Function

let b:current_syntax = "logstash"

