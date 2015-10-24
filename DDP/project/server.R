library(ISLR)
library(caret)
library(ggplot2)
data(Wage)

inTrain = createDataPartition(Wage$wage, p = 0.6, list = FALSE)
training = Wage[inTrain, ]
test = Wage[-inTrain, ]
fit = lm(wage ~ age + jobclass + maritl + education, data = training)
df = test[1, ]

shinyServer(
        function(input, output) {
                output$oid1 <- renderPrint({input$id1})
                output$oid2 <- renderPrint({input$id2})
                output$oid3 <- renderPrint({input$id3})
                output$oid4 <- renderPrint({input$id4})

                output$owage <- renderPrint({
                                predict(fit, newdata = data.frame(age = input$id1,
                                                                  jobclass = input$id2,
                                                                  maritl = input$id3,
                                                                  education = input$id4))
                        })
                
                output$coef = renderPrint({fit$coefficients}) 
                output$qq <- renderPlot({qplot(age, wage, colour = education, data = training) + geom_smooth(method = 'lm', formula = y ~ x)})
        }
)
