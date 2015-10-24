library(shiny)
shinyUI(pageWithSidebar(
        headerPanel('Wage Prediction Application'),
        sidebarPanel(
                h1('Inputs'),
                h3('Please select parameters:'),
                numericInput('id1', 'Age', 18, min = 18, max = 80, step = 1),
                radioButtons('id2', 'Job Class', choices = c('1. Industrial',
                                                             '2. Information')),
                radioButtons('id3', 'Marital Status', choices = c('1. Never Married',
                                                                  '2. Married',
                                                                  '3. Widowed',
                                                                  '4. Divorced',
                                                                  '5. Separated')),
                radioButtons('id4', 'Education', choices = c('1. < HS Grad',
                                                             '2. HS Grad',
                                                             '3. Some College',
                                                             '4. College Grad',
                                                             '5. Advanced Degree')),
                submitButton('Submit')
        ),
#         mainPanel(
#                 h1('Your parameters'),
#                 h3('You entered:'),
#                 h4('Age'), verbatimTextOutput("oid1"),
#                 h4('Job Class'), verbatimTextOutput("oid2"),
#                 h4('Marital Status'), verbatimTextOutput("oid3"),
#                 h4('Education'), verbatimTextOutput("oid4"),
# 
#                 h1('Result'),
#                 h3('Plot'), plotOutput('qq'),
#                 
#                 h3('Linear Model'),
#                 h4('Coefficients'), verbatimTextOutput("coef"),
#                 
#                 h3('Predicted Wage'), verbatimTextOutput('owage')
#         )
#         
        
        mainPanel(
                tabsetPanel(
                        tabPanel("Application", 
                                 h1('Your parameters'),
                                 h3('You entered:'),
                                 h4('Age'), verbatimTextOutput("oid1"),
                                 h4('Job Class'), verbatimTextOutput("oid2"),
                                 h4('Marital Status'), verbatimTextOutput("oid3"),
                                 h4('Education'), verbatimTextOutput("oid4"),
                                 
                                 h1('Result'),
                                 h3('Plot'), plotOutput('qq'),
                                 
                                 h3('Linear Model'),
                                 h4('Coefficients'), verbatimTextOutput("coef"),
                                 
                                 h3('Predicted Wage'), verbatimTextOutput('owage')
                                 ),
                        tabPanel("Documentation", includeMarkdown("documentation.md"))
                )
        )
        
        
        
        
        
        
))