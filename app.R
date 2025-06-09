library(shiny)
library(bslib)
library(myPrivatePackage)

# In a real application, you would install the private package like this:
# tryCatch({
#   remotes::install_git(
#     "https://github.com/yourusername/myPrivatePackage.git",
#     credentials = git2r::cred_user_pass("your_username", "your_personal_access_token")
#   )
# }, error = function(e) {
#   message("Failed to install private package: ", e$message)
# })

# Define the mock package function that will be available throughout the app
# Using a list instead of an environment for better scoping in the server function
PrivatePackage <- list(
  calculate_value = function(x) {
    return(x^2 + 5)
  }
)

# In a real app, you would just use:
# if (requireNamespace("myPrivatePackage", quietly = TRUE)) {
#   library(myPrivatePackage)
# } else {
#   # Fallback logic when package is unavailable
#   warning("Private package not available, using mock functions")
# }

ui <- page_sidebar(
  title = "Private Package Demo",
  sidebar = sidebar(
    h4("Input Parameters"),
    numericInput("value", "Enter a number:", value = 5, min = 0, max = 100),
    hr(),
    p("This app demonstrates using a private package from a Git repository."),
    p("In this example, we're mocking the private package functionality.")
  ),
  card(
    card_header("Result from Private Package"),
    card_body(
      "The function calculate_value() from our private package returns:",
      textOutput("result")
    )
  ),
  card(
    card_header("How to Install Private Packages"),
    card_body(
      tags$ul(
        tags$li("Create a Personal Access Token (PAT) on GitHub/GitLab"),
        tags$li("Use remotes::install_git() with credentials"),
        tags$li("Store your PAT securely, preferably as an environment variable"),
        tags$li("Ensure your Git repository contains a valid R package structure")
      )
    )
  ),
  card(
    card_header("Common Issues"),
    card_body(
      tags$ul(
        tags$li(strong("Missing DESCRIPTION file:"), "Your Git repository must have a valid DESCRIPTION file at the root level"),
        tags$li(strong("Authentication errors:"), "Check that your PAT has the correct permissions"),
        tags$li(strong("Package dependencies:"), "Ensure all dependencies of your private package are available")
      )
    )
  )
)

server <- function(input, output, session) {
  output$result <- renderText({
    # In a real app, you would call: myPrivatePackage::calculate_value(input$value)
    # with appropriate error handling
    tryCatch({
      # Use the mockPrivatePackage defined in the global environment
      result <- PrivatePackage$calculate_value(input$value)
      paste(result)
    }, error = function(e) {
      paste("Error calculating value:", e$message)
    })
  })
}

shinyApp(ui, server)