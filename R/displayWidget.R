#' Display Widget
#'
#' Interactive image viewer
#'
#' @param x Image
#' @param width Fixed width for widget (in css units). The default is NULL, which results in intelligent automatic sizing based on the widget's container.
#' @param height Fixed height for widget (in css units). The default is NULL, which results in intelligent automatic sizing based on the widget's container.
#' @param elementId Use an explicit element ID for the widget
#' @param embed Include images in the document as data URIs
#'
#' @importFrom htmlwidgets createWidget sizingPolicy
#' @importFrom htmltools htmlDependency
#' @importFrom png writePNG
#' @importFrom RCurl base64Encode
#' @importFrom abind abind
#' @import EBImage
#'
#' @export
displayWidget <- function(x, width = NULL, height = NULL, elementId = NULL, embed = !interactive()) {
  ## get image parameters
  d = dim(x)
  if ( length(d)==2L ) d = c(d, 1L)

  ## fill missing channels
  if ( isTRUE(colorMode(x) == Color && d[3L] < 3L) ) {
    fd = d
    fd[3L] = 3L - d[3L]
    imageData(x) = abind(x, Image(0, fd), along = 3L)
  }

  nf = EBImage:::.numberOfFrames(x, type='render')
  colormode = colorMode(x)

  x = EBImage:::clipImage(x) ## clip the image and change storage mode to double
  x = transpose(x, coerce=TRUE)

  frames = seq_len(nf)
  dependencies = NULL

  if ( isTRUE(embed) ) {

    data <- sapply(frames, function(i) base64Encode(writePNG(EBImage:::.getFrame(x, i, 'render', colormode))))
    data <- sprintf("data:image/png;base64,%s", data)

  } else {
    tempDir = tempfile("",,"")
    imageFile = tempfile("",tempDir,".png")

    if(!dir.create(tempDir))
      stop("Error creating temporary directory.")

    basename = unlist(strsplit(imageFile, split=".", fixed=TRUE))
    prefix   = basename[-length(basename)]
    suffix   = basename[length(basename)]

    files = file.path(tempDir, sprintf("frame-%d.png", frames, ".png"))

    ## store image frames into individual files
    for (i in frames)
      writePNG(EBImage:::.getFrame(x, i, 'render', colormode), files[i])

    dependencies = htmlDependency(
      name = "images",
      version = "0",
      src = list(tempDir)
    )

    filePath = file.path(sprintf("%s-%s", dependencies$name, dependencies$version), basename(files))

    ## set libdir unless run in shiny
    if ( !isNamespaceLoaded("shiny") || is.null(getDefaultReactiveDomain()))
      filePath = file.path("lib", filePath)

    data = filePath
  }

  # forward options using x
  x = list(
    data = data,
    width = d[1L],
    height = d[2L]
  )

  # create widget
  createWidget(
    name = 'displayWidget',
    x,
    width = width,
    height = height,
    package = 'displayWidget',
    elementId = elementId,
    sizingPolicy = sizingPolicy(padding = 0, browser.fill = TRUE),
    dependencies = dependencies
  )
}

#' Shiny bindings for displayWidget
#'
#' Output and render functions for using displayWidget within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a displayWidget
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name displayWidget-shiny
#'
#' @export
displayWidgetOutput <- function(outputId, width = '100%', height = '500px'){
  htmlwidgets::shinyWidgetOutput(outputId, 'displayWidget', width, height, package = 'displayWidget')
}

#' @rdname displayWidget-shiny
#' @export
renderDisplayWidget <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, displayWidgetOutput, env, quoted = TRUE)
}
