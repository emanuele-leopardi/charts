{{/*
Expand the name of the chart.
*/}}
{{- define "transmission.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "transmission.fullname" -}}
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

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "transmission.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "transmission.labels" -}}
helm.sh/chart: {{ include "transmission.chart" . }}
{{ include "transmission.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "transmission.selectorLabels" -}}
app.kubernetes.io/name: {{ include "transmission.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "transmission.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "transmission.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the correct name for the namespace
If global namespace let's use it else fullname will be used .
*/}}
{{- define "transmission.namespace" -}}
	{{- if .Values.global }}
		{{- if .Values.global.namespace }}
			{{- .Values.global.namespace | trunc 63 | trimSuffix "-" }}
		{{- else }}
			{{- include "transmission.fullname" . }}
		{{- end }}
	{{- else }}
		{{- include "transmission.fullname" . }}
	{{- end }}
{{- end }}

{{/*
See related Helm3 issues:
- https://github.com/openshift/origin/issues/24060
- https://github.com/helm/helm/issues/6830
*/}}
{{- define "chart.helmRouteFix" -}}
status:
  ingress:
    - host: ""
{{- end -}}