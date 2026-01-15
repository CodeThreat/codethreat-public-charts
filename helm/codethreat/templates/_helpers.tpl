{{- define "codethreat.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "codethreat.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{- define "codethreat.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "codethreat.labels" -}}
helm.sh/chart: {{ include "codethreat.chart" . }}
{{ include "codethreat.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "codethreat.selectorLabels" -}}
app.kubernetes.io/name: {{ include "codethreat.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "codethreat.componentLabels" -}}
{{- $context := .context -}}
{{- $component := .component -}}
{{ include "codethreat.labels" $context }}
app.kubernetes.io/component: {{ $component }}
{{- end }}

{{- define "codethreat.image" -}}
{{- $context := .context -}}
{{- $repository := .repository -}}
{{- $tag := .tag -}}
{{- if $context.Values.global.imageRegistry }}
{{- printf "%s/%s:%s" $context.Values.global.imageRegistry $repository $tag }}
{{- else }}
{{- printf "%s:%s" $repository $tag }}
{{- end }}
{{- end }}

{{- define "codethreat.databaseUrl" -}}
{{- printf "postgresql://%s:%s@%s-postgres:5432/%s" .Values.postgresql.username .Values.secrets.postgresPassword (include "codethreat.fullname" .) .Values.postgresql.database }}
{{- end }}

{{- define "codethreat.postgresService" -}}
{{- printf "%s-postgres" (include "codethreat.fullname" .) }}
{{- end }}
