% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/displayWidget.R
\name{displayWidget}
\alias{displayWidget}
\title{Display Widget}
\usage{
displayWidget(x, width = NULL, height = NULL, elementId = NULL,
  embed = !interactive())
}
\arguments{
\item{x}{Image}

\item{width}{Fixed width for widget (in css units). The default is NULL, which results in intelligent automatic sizing based on the widget's container.}

\item{height}{Fixed height for widget (in css units). The default is NULL, which results in intelligent automatic sizing based on the widget's container.}

\item{elementId}{Use an explicit element ID for the widget}

\item{embed}{Include images in the document as data URIs}
}
\description{
Interactive image viewer
}
