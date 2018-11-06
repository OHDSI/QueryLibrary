# Borrowed from SqlRender/ShinyApp: https://github.com/OHDSI/SqlRender/blob/master/inst/shinyApps/SqlDeveloper/widgets.R

menuItemFileInput <- function(inputId, text, icon = shiny::icon("file-text-o")) {
  script <- "document.getElementById('%id%').click(); return false;"
  script <- gsub("%id%", inputId, script)
  list(div(fileInput(inputId, ""), style = "display: none;"),
       tags$li(class = "treeview", a(href = "#", onclick = script, icon, text)))
}


menuItemDownloadLink <- function(inputId, label, icon = shiny::icon("floppy-o")) {
  tags$li(class = "treeview",
          tags$a(id = inputId,
                 class = "shiny-download-link",
                 href = "",
                 target = "_blank",
                 download = NA,
                 icon,
                 label)
  )
}


menuItemCopyTextAreaToClipboard <- function(textAreaId, label, icon = shiny::icon("clipboard")) {
  script <- "
  element = $('<textarea>').appendTo('body').val(document.getElementById('%id%').value).select();
  document.execCommand('copy');
  element.remove();
  return false;
  "
  script <- gsub("%id%", textAreaId, script)
  tags$li(class = "treeview", a(href = "#", onclick = script, icon, label))
}

menuItemCopyDivToClipboard <- function(divId, label, icon = shiny::icon("clipboard")) {
  script <- "
  element = $('<textarea>').appendTo('body').val(document.getElementById('%id%').textContent).select();
  document.execCommand('copy');
  element.remove();
  return false;
  "
  script <- gsub("%id%", divId, script)
  tags$li(class = "treeview",a(href = "#", onclick = script, icon, label))
}

buttonCopyTextAreaToClipboard <- function(inputId, textAreaId, label, icon = shiny::icon("clipboard")) {
  script <- "
  element = $('<textarea>').appendTo('body').val(document.getElementById('%id%').value).select();
  document.execCommand('copy');
  element.remove();
  return false;
  "
  script <- gsub("%id%", textAreaId, script)
  tags$button(id=inputId,class = "btn btn-default action-button shiny-bound-input", onclick = script, icon, label)
}

buttonDownloadTextArea <-
  function(inputId,
           textAreaId,
           label,
           icon = shiny::icon("floppy-o")) {
    script <- "    var a = document.body.appendChild(
    document.createElement('a')
    );
    a.download = 'export.html';
    a.href = 'data:text/html,' + document.getElementById('%id%').innerHTML; // Grab the HTML
    a.click(); // Trigger a click on the element"
    
    script <- gsub("%id%", textAreaId, script)
    tags$button(id = inputId,
                class = "btn btn-default action-button shiny-bound-input",
                onclick = script,
                icon,
                label)
  }