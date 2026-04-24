{{/*
Expand the name of the chart.
*/}}
{{- define "ricochet.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "ricochet.fullname" -}}
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
{{- define "ricochet.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "ricochet.labels" -}}
helm.sh/chart: {{ include "ricochet.chart" . }}
{{ include "ricochet.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "ricochet.selectorLabels" -}}
app.kubernetes.io/name: {{ include "ricochet.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "ricochet.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "ricochet.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Return the proper image name
*/}}
{{- define "ricochet.image" -}}
{{- $registry := .Values.image.registry -}}
{{- $repository := .Values.image.repository -}}
{{- $tag := .Values.image.tag | default .Chart.AppVersion -}}
{{- printf "%s/%s:%s" $registry $repository $tag -}}
{{- end }}

{{/*
Return the proper image pull policy
*/}}
{{- define "ricochet.imagePullPolicy" -}}
{{- .Values.image.pullPolicy | default "IfNotPresent" -}}
{{- end }}

{{/*
Return the init container image name
*/}}
{{- define "ricochet.initContainerImage" -}}
{{- $registry := .Values.initContainerImage.registry -}}
{{- $repository := .Values.initContainerImage.repository -}}
{{- $tag := .Values.initContainerImage.tag -}}
{{- printf "%s/%s:%s" $registry $repository $tag -}}
{{- end }}

{{/*
Detect whether the target cluster is OpenShift by probing for
OpenShift-specific API groups. Relies on .Capabilities, which is populated
during `helm install` / `helm upgrade`; `helm template` without `--validate`
falls back to "not OpenShift" (vanilla Kubernetes).
*/}}
{{- define "ricochet.isOpenShift" -}}
{{- or (.Capabilities.APIVersions.Has "security.openshift.io/v1") (.Capabilities.APIVersions.Has "route.openshift.io/v1") -}}
{{- end }}

{{/*
Resolve persistence.home.fixPermissions.enabled with auto-detection.
Returns the literal string "true" or "false".
  - Explicit bool value wins.
  - null (default) → enabled unless OpenShift is detected (SCC typically
    blocks root init containers).
*/}}
{{- define "ricochet.fixPermissions.enabled" -}}
{{- $v := .Values.persistence.home.fixPermissions.enabled -}}
{{- if kindIs "bool" $v -}}
{{- $v -}}
{{- else -}}
{{- not (eq (include "ricochet.isOpenShift" .) "true") -}}
{{- end -}}
{{- end }}
