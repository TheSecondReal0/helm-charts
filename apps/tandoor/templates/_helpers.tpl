{{- define "tandoor.name" -}}
tandoor
{{- end }}

{{- define "tandoor.fullname" -}}
{{ include "tandoor.name" . }}-{{ .Release.Name }}
{{- end }}

