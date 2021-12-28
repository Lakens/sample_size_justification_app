library(shiny)
library(shinydashboard)
library(shinyjs)
library(rmarkdown)
library(knitr)
library(kableExtra)

ui <- dashboardPage(
  skin = "blue",
  dashboardHeader(
    title = "Sample Size Justification",
    titleWidth = "calc(100% - 44px)"
  ),
  dashboardSidebar(
    collapsed = FALSE,
    sidebarMenu(id = "tabs",
      menuItem("About", tabName = "about", icon = icon("info")),
      menuItem("Justification Flowchart",
        tabName = "flowchart", startExpanded = TRUE,
        icon = icon("calculator"),
        menuSubItem("Part A: Sample Description", tabName = "part_a"),
        menuSubItem("Part B: Effects of Interest", tabName = "part_b"),
        menuSubItem("Part C: Inferential Goal", tabName = "part_c"),
        menuSubItem("Part D: Informational Value", tabName = "part_d")
      )
    )
  ),
  dashboardBody(
    fluidRow(
      column(width = 12,
    shinyjs::useShinyjs(),
    tabItems(
      tabItem(
        tabName = "about",
        h4("This Shiny app accompanies the paper 'Sample Size Justification' by Daniël Lakens. You can download the pre-print of this article at ", a("PsyArXiV", href = "https://psyarxiv.com/9d3yf/"), ". You can help to improve this app by providing feedback or suggest additions by filling out ", a("this feedback form", href = "https://docs.google.com/forms/d/e/1FAIpQLSdWAtBdv2VnlIWMwSeHK9syZnAw5P2Q9yJs_9hvFy0j9daSYQ/viewform?usp=sf_link", target="_blank","."),
           HTML("<br><br>The main goal of this app and the accompanying paper is to guide you through an evaluation of the <b>informational value</b> of a planned study. After filling out this form you can download a report of your sample size justification."),
           HTML("<br><br>The informational value of a study depends on the <b>inferential goal</b>, which could be testing a hypothesis, obtaining an accurate estimate, or seeing what you can learn from all the data you have the resources to collect."),
           HTML("<h4><ul><li>It is possible that your resource constraints allow you to perform a study that has: 
          <ul><li> a desired <b>statistical power</b>, or </ul></li> 
          <ul><li>  a desired <b>accuracy of the estimated effect</b></ul></li> 
          and your resource constraints are not the primary reason to collect a specific sample size (even though resource constraints are always a secondary reason to collect a certain sample size, as without resource constraints, one would for example choose a very low alpha level and design a study that has incredibly high statistical power). In these cases, you would:
          <ul><li> perform an a-priori <b>power analysis</b> for the <b>smallest effect sizes of interest</b> or, if that can not be specified, for an a-priori power analysis for an <b>expected effect size</b>.</ul></li> 
          <ul><li> determine the sample size using an <b>accuracy in parameter estimates</b> perspective, based on the <b>desired accuracy</b> and the <b>expected effect size</b>.</ul></li></h4>
          <h4><ul><li>It is also possible that the calculations based on power and accuracy yield a sample size that is larger than you have the resources to collect. In these situations, you can:
          <ul><li> not draw any inferences, and collect the data so they can be included in a <b>future meta-analysis</b>.</ul></li> 
          <ul><li> justify the sample size because a <b>decision</b> needs to be made, even if data is scarce, and design a study based on a <b> compromise power analysis</b> that allows you to sufficiently reduce the relative probability of Type 1 and Type II error rates based on a cost-benefit analysis</ul></li>
          <ul><li> If you still want to perform a hypothesis test, perform a <b>sensitivity power analysis</b>, justify the sample size based on the information it will provide about the <b>expected effect size</b> or other effect sizes of interest, such as effects previously observed in the literature. 
          If you plan to perform a hypothesis test, examine if the <b>minimal statistically detectable effect</b> is large enough to warrant a hypothesis test, and evaluate whether the Type 1 error rate and the Type II error rate make it possible to draw useful conclusions based on the <i>p</i>-value, or not.</ul></li>
          <ul><li>If you want to estimate an effect size, interpret the <b>width of the confidence interval around the estimate</b>, and specify what an estimate with this accuracy is useful for.</ul></li>
          </ul></li></h4>
          
          "),
           actionButton('jump_to_a', 'Continue to the Sample Description Tab'),
        )
      ),
      # Sample description
      tabItem(
        tabName = "part_a",
        h2("Describe Your Population"),
        box(
          collapsible = TRUE, title = "Describe the population and its size", solidHeader = TRUE, status = "primary", width = 12, 
          h4("Describe the population you are sampling from, including its estimated size when the population is finite. Indicate methods of recruitment, selection and inclusion/exclusion criteria, details of any stratification sampling used, planned participant characteristics, and compensation amount and method. (Overlaps with M4 in the ", a("PQRP checklist", href = "https://docs.google.com/spreadsheets/d/1vlp5GN-HXrtrjCdjE28f_3tT6RiwhQO2vVeOZGOaFsQ/edit#gid=0", target="_blank"),")."),
          textAreaInput("population", rows = 5, "")
        ),
        box(
          collapsible = TRUE, title = "Can you collect data from the entire population?", solidHeader = TRUE, status = "primary", width = 12, 
          selectInput(
          "collect_entire_population", "",
          c("no", "yes"))
        ),
        hidden(tags$div(
          id = "describe_constraints_q",
          box(
            collapsible = TRUE, title = "Describe your resource constraints.", solidHeader = TRUE, status = "primary", width = 12, 
            h4(HTML("Describe your <b>resource constraints</b> (e.g., time and money), and how these limit the <b>maximum sample size</b> you are willing and able to collect. Note that in the subsequent steps, you might provide justifications to collect a smaller sample size than this maximum. It is also possible that the maximum sample size based on resource constraints is the main justification for the sample size (i.e., a <b>resource constraints justification</b>). This happens when, for example, an a-priori power analysis for the smallest effect size of interest yields a required sample size that is larger than the resources you have available. This is common, as there are almost always resource constraints, but it requires a careful evaluation of the informational value of the study. ")),
              textAreaInput("describe_constraints", NULL, rows = 5,
            placeholder = ""
          ),
          )
        )),
        actionButton('jump_to_b', 'Continue to the Effects of Interest Tab'),
      ),
      # Effect sizes of interest
      tabItem(
        tabName = "part_b",
        h2("Which Effect Sizes are of Interest?"),
        h4(HTML("<br><br>A shared feature of the different inferential goals (see Part C) is the question which effect sizes a researcher considers meaningful to learn about. 
        This implies that researchers need to evaluate which effect sizes they consider interesting. These evaluations rely on a combination of statistical properties and domain knowledge."),
        HTML("<br><br>If your inferential goal is a <b>statistical hypothesis test</b>, and you plan to perform an <b>a-priori power analysis</b>, best practice is to design a study well-powered for a <b>smallest effect size of interest</b>. 
           Alternatively, design a study that is well powered for an <b>expected effect size</b> (either based on related studies in the literature, or other sources of expectations)."),
        HTML("<br><br>If your inferential goal is an <b>accurate estimate</b>, provide an answer to the <b>expected effect size</b> (either based on a meta-analysis, related studies in the literature, or other sources of expectations)."),
        HTML("<br><br>If your sample size justification is based on <b>resource constraints</b>, compute the <b>minimal statistically detectable effect</b> given the sample size you can collect. You can also specify the smallest effect size of interest, or an expected effect size, and examine the power for these effects in a sensitivty power analysis. If this is not possible, a last resort is to consider the <b>distribution of effects in a specific literature</b>, to evaluate the likelihood that the data will provide information about the presence of absence of effects of the size one typically encounters in a specific literature."),
        HTML("<br><br>You can leave any or all of the fields below empty.")),
      
        box(
          collapsible = TRUE, title = "Smallest Effect Size of Interest", solidHeader = TRUE, status = "primary", width = 12, 
          h4("What is the smallest effect size of interest (specify the metric and the value)? What is the justification to consider this the smallest effect size of interest? For example, is this the smallest effect that would be practically relevant, theoretically predicted, or that would reject a previously observed effect using the Small Telescopes approach?"),
          numericInput("sesoi_effect_value", "What is the value of the smallest effect size of interest?", value = "", step = 0.01),
          selectInput(
            "sesoi_effect_metric", "What is the effect size metric used above?",
            c("", "Cohen's d", "Hedges' g", "Cohen's dz", "Correlation", "Odds Ratio", "Risk Ratio", "Proportion Effect Size g", "Cohen's f", "Partial Eta Squared", "Partial Omega Squared", "Cohen's w (contingency table)", "Phi (contingency table)", "Cramer's V (contingency table)", "Cohen's q (correlation differences)", "Cohen's h (independent proportions)", "Other. Specify in the field below")
          ),
          textAreaInput("effect_of_interest", "Add any justifications for the effect size above, including any code used to compute the value. If the smallest effect of interest is not based on a simple effect, but on a more complex data pattern, leave the 'value' field empty, and choose 'Other. Specify in the field below' in the 'metric' field.", rows = 5, "")
        ),
        box(
          collapsible = TRUE, title = "Minimal Statistically Detectable Effect", solidHeader = TRUE, status = "primary", width = 12, 
          h4("What is the minimal statistically detectable effect? How was the minimal statistically detectable effect computed (preferably in code)?"),
          numericInput("statistically_detectable_effect_value", "What is the value of the minimal statistically detectable effect size?", value = "", step = 0.01),
          selectInput(
            "statistically_detectable_effect_metric", "What is the effect size metric used above?",
            c("", "Cohen's d", "Hedges' g", "Cohen's dz", "Correlation", "Odds Ratio", "Risk Ratio", "Proportion Effect Size g", "Cohen's f", "Partial Eta Squared", "Partial Omega Squared", "Cohen's w (contingency table)", "Phi (contingency table)", "Cramer's V (contingency table)", "Cohen's q (correlation differences)", "Cohen's h (independent proportions)", "Other. Specify in the field below")
          ),
            textAreaInput("minimal_detectable", "Add any justifications for the effect size above, including any code used to compute the value. If the minimal statistically detectable effect is not based on a simple effect, but on a more complex data pattern, leave the 'value' field empty, and choose 'Other. Specify in the field below' in the 'metric' field.", rows = 5, "")
        ),
        box(
          collapsible = TRUE, title = "Expected Effect Size", solidHeader = TRUE, status = "primary", width = 12, 
          h4("What is the expected effect size, and why?"),
          h4("What is the source of the expected effect size? E.g., a meta-analysis, a previous study, or a subjective prior belief. If applicable, cite the source, and add a direct quote or table number that contains the effect size estimate."),
          h4("Can the effect size from the source be expected to generalize to the planned study? For a meta-analyses with large heterogeneity, what is the effect size in the most heterogenous subset?"),
          h4("Is there a risk of bias in the effect size estimate, and if relevant, is the source effect size adjusted in any way?"),
          h4("Below, choose either the options that the expected effect size is based on a meta-analysis, or choose the option that the expected effect size is based on a previous study, or specify what the source of the expectation was in the main text field."),
          # Expected effect based on meta-analysis?
          box(
            collapsible = TRUE, title = "Is the expected effect size based on a meta-analysis?", solidHeader = TRUE, status = "primary", width = 12, 
            selectInput(
              "expected_effect_from_meta", "",
              c("no", "yes"))
          ),
          hidden(tags$div(
            id = "describe_effect_expectation_meta_q",
            box(
              collapsible = TRUE, title = "Recommendations for effect size estimates from a meta-analysis.", solidHeader = TRUE, status = "primary", width = 12, 
              h4("Are the studies in the meta-analysis similar to the study you are planning? Evaluate the generalizability of the effect size in the meta-analysis to your study.  Include a citation to the meta-analysis, and if possible copy-paste text from the meta-analysis that reports the effect size."),
              textAreaInput("describe_similarity_meta", NULL, rows = 5,
                            placeholder = ""
              ),
              h4("Are the studies in the meta-analysis homogeneous? If there is a lot of heterogeneity, which subsample of studies would be most relevant to the study you are planning?"),
              textAreaInput("describe_homogeneity_meta", NULL, rows = 5,
                            placeholder = ""
              ),
              h4("Is the meta-analytic effect size estimate unbiased? If not, can you compute an effect size estimate that attempts to correct for bias, or will you use a more conservative effect size estimate?"),
              textAreaInput("describe_bias_meta", NULL, rows = 5,
                            placeholder = ""
              ),
              numericInput("expected_effect_value_meta", "What is the value of the expected effect size?", value = "", step = 0.01),
              selectInput(
                "expected_effect_metric_meta", "What is the effect size metric used above?",
                c("", "Cohen's d", "Hedges' g", "Cohen's dz", "Correlation", "Odds Ratio", "Risk Ratio", "Proportion Effect Size g", "Cohen's f", "Partial Eta Squared", "Partial Omega Squared", "Cohen's w (contingency table)", "Phi (contingency table)", "Cramer's V (contingency table)", "Cohen's q (correlation differences)", "Cohen's h (independent proportions)", "Other. Specify in the field below")
              ))
          )),
          # Expected effect based on single study?
          box(
            collapsible = TRUE, title = "Is the expected effect size based on a previous study?", solidHeader = TRUE, status = "primary", width = 12, 
            selectInput(
              "expected_effect_from_study", "",
              c("no", "yes"))
          ),
          hidden(tags$div(
            id = "describe_effect_expectation_study_q",
            box(
              collapsible = TRUE, title = "Recommendations for effect size estimates from a single study.", solidHeader = TRUE, status = "primary", width = 12, 
              h4("Is the previous study similar to the study you are planning? Evaluate the generalizability of the effect size in the previous study to your study. Include a citation to the study, and if possible copy-paste text from the original study that reports the effect size."),
              textAreaInput("describe_similarity_study", NULL, rows = 5,
                            placeholder = ""
              ),
              h4("How large is the uncertainty in the effect size estimate of the previous study? How have you dealt with this uncertainty (e.g., choosing a more conservative effect size)?"),
              textAreaInput("describe_uncertainty_study", NULL, rows = 5,
                            placeholder = ""
              ),
              h4("Is the effect size estimate unbiased? If not, can you compute an effect size estimate that attempts to correct for bias, or will you use a more conservative effect size estimate?"),
              textAreaInput("describe_bias_study", NULL, rows = 5,
                            placeholder = ""
              ),
              numericInput("expected_effect_value_study", "What is the value of the expected effect size?", value = "", step = 0.01),
              selectInput(
                "expected_effect_metric_study", "What is the effect size metric used above?",
                c("", "Cohen's d", "Hedges' g", "Cohen's dz", "Correlation", "Odds Ratio", "Risk Ratio", "Proportion Effect Size g", "Cohen's f", "Partial Eta Squared", "Partial Omega Squared", "Cohen's w (contingency table)", "Phi (contingency table)", "Cramer's V (contingency table)", "Cohen's q (correlation differences)", "Cohen's h (independent proportions)", "Other. Specify in the field below")
              ))
          )),
          textAreaInput("expected_effect", "Add any justifications for the expected effect size, including any code used to compute the value. If the expected effect size from a meta-analysis or previous study is not based on a simple effect, but on a more complex data pattern, leave the 'value' field empty, and choose 'Other. Specify in the field below' in the 'metric' field.", rows = 15, "")
        ),
        box(
          collapsible = TRUE, title = "Distribution of Effect Sizes", solidHeader = TRUE, status = "primary", width = 12, 
          h4("What is the distribution of effect sizes in this research area? Add a citation to a meta-meta-analysis, where possible."),
          textAreaInput("distribution_effect", rows = 5, "")
        ),
        actionButton('jump_to_c', 'Continue to the Inferential Goal Tab'),
      ),
      # Inferential Goal
      tabItem(
        tabName = "part_c",
        h2("Specify the Inferential Goal."),
        h4("By collecting a certain amount of data, researchers aim to reach an inferential goal. Therefore, "),
        box(
          collapsible = TRUE, title = "B1: Input for Future Meta-Analysis", solidHeader = TRUE, status = "primary", width = 12, 
          h4("Will this study mainly serve as input for a future meta-analysis (and will no inferences be drawn from this dataset in isolation?"),
          selectInput(
            "meta_analysis", "",
            c("no", "yes")
          )),
        hidden(tags$div(
          id = "meta_q",
          box(
            collapsible = TRUE, title = "How will the meta-analysis be realized?", solidHeader = TRUE, status = "primary", width = 12, 
            h4("Reflect on the probability that a future meta-analysis will be performed, how you will help to realize such a meta-analysis."),
            textAreaInput("will_meta_be_performed", NULL,
                          rows = 5, label = ""
            ))
        )),
        
        # decision section
          box(id = "decision_q",
            collapsible = TRUE, title = "B2: Decision", solidHeader = TRUE, status = "primary", width = 12, 
            h4("Is there a clear need to make a decision about how to act based on the results of this study?"),
            selectInput(
              "decision", "",
              c("no", "yes")
            )
        ),
        hidden(tags$div(
          id = "decision_sub_q",
          box(
            collapsible = TRUE, title = "Specify cost/benefit considerations", solidHeader = TRUE, status = "primary", width = 12, 
            h4("Specify the parameters of the cost/benefit trade-off used in the power analysis."),
            numericInput("relative_cost", "Relative Cost Type 1 Error vs. Type 2 Error", value = 4),
            numericInput("alpha_level", "Alpha level", value = 0.05, min = 0, max = 1, step = 0.001),
            numericInput("power", "Desired level of statistical power", value = 0.90, min = 0, max = 1, step = 0.01),
            textAreaInput("relative_cost_code", NULL, rows = 5, label = "Provide a justification for the relative cost (including any computations this justification is based on). Provide a justification for the chosen alpha level and power. Include details about the power calculation (preferably in reproducible code).", placeholder = "t tests - Means: Difference between two independent means (two groups)
Analysis:	Compromise: Compute implied α & power 
Input:	Tail(s)	=	Two
	Effect size d	=	0.3
	β/α ratio	=	4
	Sample size group 1	=	210
	Sample size group 2	=	210
Output:	Noncentrality parameter δ	=	3.0740852
	Critical t	=	2.0672112
	Df	=	418
	α err prob	=	0.0393293
	β err prob	=	0.1573171
	Power (1-β err prob)	=	0.8426829
"
            ))
        )),
        # estimation section
          box(id = "estimate_q",
            collapsible = TRUE, title = "B3: Estimation", solidHeader = TRUE, status = "primary", width = 12, 
            h4("Is your inferential goal to estimate the size of a parameter?"),
            selectInput(
              "estimate", "",
              c("no", "yes")
            )
        ),
        hidden(tags$div(
          id = "estimate_sub_q",
          box(
            collapsible = TRUE, title = "Estimation details.", solidHeader = TRUE, status = "primary", width = 12, 
            h4("Specify the parameters related to the desired estimation accuracy."),
            selectInput(
              "interval_metric", "Which type of interval is the decision based on?",
              c("", "Confidence Interval", "Prediction Interval", "Highest Density Interval", "Other. Specify in the Sample Size Computation field")
            ),
            numericInput("desired_accuracy", "What is the desired level of accuracy of the interval specified above?", value = 0.95, min = 0, max = 1, step = 0.01),
            numericInput("assurance", "[Optional] What is the specified degree of assurance that the obtained confidence interval will be sufficiently narrow?", value = NULL, min = 0, max = 1, step = 0.001),
            textAreaInput("estimation_code", NULL,
                          rows = 5, label = "Sample Size Computation",
                          placeholder = "Computation of the sample size to reach a desired accuracy (preferably in code)?"
            ))
        )),
        # power section
          box(id = "power_q",
            collapsible = TRUE, title = "B4: Power", solidHeader = TRUE, status = "primary", width = 12, 
            h4("Is your inferential goal to achieve a desired statistical power for a statistical test?"),
            selectInput(
              "power_goal", "",
              c("no", "yes")
            )
        ),
        hidden(tags$div(
          id = "power_sub_q",
          box(
            collapsible = TRUE, title = "Power calculation.", solidHeader = TRUE, status = "primary", width = 12, 
            h4("Specify the parameters related to the statistical power calculation. If you have multiple hypothesis tests in your study"),
            selectInput(
              "power_type", "What type of power analysis have you performed?",
              c("a-priori power analysis", "sensitivity power analysis", "compromise power analysis")
            ),
            numericInput("alpha_level", "Alpha level", value = 0.05, min = 0, max = 1, step = 0.001),
            hidden(tags$div(
              id = "desired_power_sub_q",
              numericInput("power", "Desired level of statistical power", value = 0.90, min = 0, max = 1, step = 0.01),
            )),
            hidden(tags$div(
              id = "relative_cost_sub_q",
            numericInput("relative_cost", "Relative Cost Type 1 Error vs. Type 2 Error", value = 4),
            )),
            textAreaInput("power_analysis_code", NULL,rows = 5, label = "Provide a justification for the chosen alpha level and power. Include details about the power calculation (preferably in reproducible code). For a sensitivity power analysis, report the achieved power for effect sizes of interest.", placeholder = 
            "t tests - Means: Difference between two independent means (two groups)
Analysis:	A priori: Compute required sample size 
Input:	Tail(s)	=	Two
	Effect size d	=	0.3
	α err prob	=	0.01
	Power (1-β err prob)	=	0.9
	Allocation ratio N2/N1	=	1
Output:	Noncentrality parameter δ	=	3.8710464
	Critical t	=	2.5832538
	Df	=	664
	Sample size group 1	=	333
	Sample size group 2	=	333
	Total sample size	=	666
	Actual power	=	0.9006980
"
            ))
        )),
        actionButton('jump_to_d', 'Continue to the Informational Value Tab'),
        
      ),
      #  Informational Value
      tabItem(
        tabName = "part_d",
        h4("Based on the resource constraints, the effects of interest, and the inferential goals, specify the sample size you plan to collect, and evaluate the informational value of the study."),
        box(
          collapsible = FALSE, title = "Total number of participants", solidHeader = TRUE, status = "primary", width = 12, 
          numericInput("participants", NULL, value = "")),
        box(
          collapsible = FALSE, title = "Total observations per participant", solidHeader = TRUE, status = "primary", width = 12, 
          numericInput("observations", NULL, value = "")),
        box(
          collapsible = FALSE, title = "Additional details about the sample size", solidHeader = TRUE, status = "primary", width = 12, 
          h4("Describe the distribution of participants or observations across conditions, how you plan to deal with missing data, or any other information that determines the information this data can provide in relation to the inferential goal."),
          textAreaInput("participants_details", NULL, rows = 5)),
      HTML("<h4><b>Given the following resource constraints:</b></h4>"),
        textOutput("final_summary_text_1", container = tags$h4),
        HTML("<h4><b>Given the following effects of interest:</b></h4>"),
        textOutput("final_summary_text_2", container = tags$h4),
        textOutput("final_summary_text_3", container = tags$h4),
        textOutput("final_summary_text_4", container = tags$h4),
        HTML("<h4><b>Given the following inferential goal:</b></h4>"),
        textOutput("final_summary_text_5", container = tags$h4),
      HTML("<h4><b>Please explain what the the informational value of the sample size that will be collected is, given any resource constraints, the effects of interest, and the inferential goal.</b></h4>"),
        box(
          collapsible = FALSE, title = "Informational Value of the Study", solidHeader = TRUE, status = "primary", width = 12, 
          textAreaInput("informational_value", NULL, rows = 10)),
      HTML("<br><br><h4><b>You can download a html report of your sample size justification(for example to add it to a preregistration of your study) by clicking the button below.</b></h4>"),
      downloadButton("report", "Download Report")
      )
      ))
    )
  )
)

server <- function(input, output, session) {
  
  observeEvent(input$jump_to_a, {
    updateTabItems(session, "tabs", "part_a")
  })
  observeEvent(input$jump_to_b, {
    updateTabItems(session, "tabs", "part_b")
  })
  observeEvent(input$jump_to_c, {
    updateTabItems(session, "tabs", "part_c")
  })
  observeEvent(input$jump_to_d, {
    updateTabItems(session, "tabs", "part_d")
  })
  
  # Save data
  values <- reactiveValues(population = 0)
  observeEvent(input$population, {values$population <- input$population})
  observeEvent(input$describe_constraints, {values$describe_constraints <- input$describe_constraints})
  observeEvent(input$collect_entire_population, {values$collect_entire_population <- input$collect_entire_population})
  observeEvent(input$effect_of_interest, {values$effect_of_interest <- input$effect_of_interest})
  observeEvent(input$minimal_detectable, {values$minimal_detectable <- input$minimal_detectable})
  observeEvent(input$expected_effect, {values$expected_effect <- input$expected_effect})
  observeEvent(input$expected_effect_metric_meta, {values$expected_effect_metric_meta <- input$expected_effect_metric_meta})
  observeEvent(input$expected_effect_metric_study, {values$expected_effect_metric_study <- input$expected_effect_metric_study})
  observeEvent(input$expected_effect_value_meta, {values$expected_effect_value_meta <- input$expected_effect_value_meta})
  observeEvent(input$expected_effect_value_study, {values$expected_effect_value_study <- input$expected_effect_value_study})
  observeEvent(input$sesoi_effect_value, {values$sesoi_effect_value <- input$sesoi_effect_value})
  observeEvent(input$sesoi_effect_metric, {values$sesoi_effect_metric <- input$sesoi_effect_metric})
  observeEvent(input$statistically_detectable_effect_value, {values$statistically_detectable_effect_value <- input$statistically_detectable_effect_value})
  observeEvent(input$statistically_detectable_effect_metric, {values$statistically_detectable_effect_metric <- input$statistically_detectable_effect_metric})
  observeEvent(input$expected_effect_from_meta, {values$expected_effect_from_meta <- input$expected_effect_from_meta})
  observeEvent(input$describe_similarity_meta, {values$describe_similarity_meta <- input$describe_similarity_meta})
  observeEvent(input$describe_homogeneity_meta, {values$describe_homogeneity_meta <- input$describe_homogeneity_meta})
  observeEvent(input$describe_bias_meta, {values$describe_bias_meta <- input$describe_bias_meta})
  observeEvent(input$expected_effect_from_study, {values$expected_effect_from_study <- input$expected_effect_from_study})
  observeEvent(input$describe_similarity_study, {values$describe_similarity_study <- input$describe_similarity_study})
  observeEvent(input$describe_uncertainty_study, {values$describe_uncertainty_study <- input$describe_uncertainty_study})
  observeEvent(input$describe_bias_study, {values$describe_bias_study <- input$describe_bias_study})
  observeEvent(input$distribution_effect, {values$distribution_effect <- input$distribution_effect})
  observeEvent(input$meta_analysis, {values$meta_analysis <- input$meta_analysis})
  observeEvent(input$decision, {values$decision <- input$decision})
  observeEvent(input$relative_cost, {values$relative_cost <- input$relative_cost})
  observeEvent(input$alpha_level, {values$alpha_level <- input$alpha_level})
  observeEvent(input$power, {values$power <- input$power})
  observeEvent(input$effect_size, {values$effect_size <- input$effect_size})
  observeEvent(input$effect_metric_1, {values$effect_metric_1 <- input$effect_metric_1})
  observeEvent(input$effect_metric_2, {values$effect_metric_2 <- input$effect_metric_2})
  observeEvent(input$relative_cost_code, {values$relative_cost_code <- input$relative_cost_code})
  observeEvent(input$estimate, {values$estimate <- input$estimate})
  observeEvent(input$interval_metric, {values$interval_metric <- input$interval_metric})
  observeEvent(input$desired_accuracy, {values$desired_accuracy <- input$desired_accuracy})
  observeEvent(input$assurance, {values$assurance <- input$assurance})
  observeEvent(input$estimation_code, {values$estimation_code <- input$estimation_code})
  observeEvent(input$power_goal, {values$power_goal <- input$power_goal})
  observeEvent(input$power_type, {values$power_type <- input$power_type})
  observeEvent(input$power_analysis_code, {values$power_analysis_code <- input$power_analysis_code})
  observeEvent(input$participants, {values$participants <- input$participants})
  observeEvent(input$observations, {values$observations <- input$observations})
  observeEvent(input$participants_details, {values$participants_details <- input$participants_details})
  observeEvent(input$informational_value, {values$informational_value <- input$informational_value})
  
  observeEvent(input$collect_entire_population, {
    if (input$collect_entire_population == "no") {
      show("describe_constraints_q")
    } else {
      hide("describe_constraints_q")
    }
  })

  observeEvent(input$expected_effect_from_meta, {
    if (input$expected_effect_from_meta == "yes") {
      show("describe_effect_expectation_meta_q")
    } else {
      hide("describe_effect_expectation_meta_q")
    }
  })

  observeEvent(input$expected_effect_from_study, {
    if (input$expected_effect_from_study == "yes") {
      show("describe_effect_expectation_study_q")
    } else {
      hide("describe_effect_expectation_study_q")
    }
  })
  
  observeEvent(input$meta_analysis, {
    if (input$meta_analysis == "yes") {
      show("meta_q")
    } else {
      hide("meta_q")
    }
  })

  observeEvent(input$decision, {
    if (input$decision == "yes") {
      show("decision_sub_q")
    } else {
      hide("decision_sub_q")
    }
  })

  observeEvent(input$estimate, {
    if (input$estimate == "yes") {
      show("estimate_sub_q")
    } else {
      hide("estimate_sub_q")
    }
  })

  observeEvent(input$power_goal, {
    if (input$power_goal == "yes") {
      show("power_sub_q")
    } else {
      hide("power_sub_q")
    }
  })
  
  observeEvent(input$power_type, {
    if (input$power_type == "sensitivity power analysis") {
      hide("desired_power_sub_q")
    } else {
      show("desired_power_sub_q")
    }
  })
  
  observeEvent(input$power_type, {
    if (input$power_type == "compromise power analysis") {
      show("relative_cost_sub_q")
    } else {
      hide("relative_cost_sub_q")
    }
  })
  
  final_summary_text_1 <- reactive(input$describe_constraints)
  final_summary_text_2 <- reactive(if(is.na(input$sesoi_effect_value) == FALSE){paste0("A smallest effect size of interest size of ", input$sesoi_effect_metric, " = ", input$sesoi_effect_value,".")})
    final_summary_text_3 <- reactive(if(is.na(input$statistically_detectable_effect_value) == FALSE){paste0("A minimal statistically detectable effect of ", input$statistically_detectable_effect_metric, " = ", input$statistically_detectable_effect_value, ".")})
    final_summary_text_3 <- reactive(if(input$expected_effect_from_meta == "yes") {paste0("An expected effect size of ", input$expected_effect_metric_meta, " = ", input$expected_effect_value_meta,"")
    })
    final_summary_text_4 <- reactive(if(input$expected_effect_from_study == "yes") {paste0("An expected effect size of ", input$expected_effect_metric_study, " = ", input$expected_effect_value_study,"")
    })
    
    power_desired <- reactive(
    if(input$power_type == "a-priori power analysis"){
      paste0(", and the desired power is ", input$power,".")
    }
    else if(input$power_type == "compromise power analysis"){
      paste0(", and the desired power is ", input$power,".")
    }
    else if(input$power_type == "sensitivity power analysis"){
      paste("")
    })
    
    
    final_summary_text_5 <- reactive(
    if(input$power_goal == "yes") {
      inferential_goal_final_summary <- paste0("The inferential goal is based on a ", input$power_type, " with an alpha level of ", input$alpha_level, power_desired())
    } else if (
      input$estimate == "yes") {
      inferential_goal_final_summary <- paste0("The inferentional goal is to estimate parameters with a desired accuracy ", input$desired_accuracy, " ", input$estimate_metric, ".")
    } else if (
      input$decision == "yes") {
      inferential_goal_final_summary <- paste0("The inferentional goal is to make a decision based on the judgment that a Type I error is ", input$relative_cost, " times as costly as a Type II error, the chosen alpha level is ", input$alpha_level, ", and the desired power is ", input$power)
    })
    
    
    
    output$final_summary_text_1 <- renderText(final_summary_text_1())
    output$final_summary_text_2 <- renderText(final_summary_text_2())
    output$final_summary_text_3 <- renderText(final_summary_text_3())
    output$final_summary_text_4 <- renderText(final_summary_text_4())
    output$final_summary_text_5 <- renderText(final_summary_text_5())
    
    
  ###############################################################################
  # Create downloadable report in markdown TINYTEX NEEDS TO BE INSTALLED
  # INstall from https://tug.org/texlive/acquire-netinstall.html
  output$report <- downloadHandler(
    # For PDF output, change this to "report.pdf"
    filename = "report.html",
    content = function(file) {
      # Copy the report file to a temporary directory before processing it, in
      # case we don't have write permissions to the current working dir (which
      # can happen when deployed).
      tempReport <- file.path(tempdir(), "report.Rmd")
      file.copy("report.Rmd", tempReport, overwrite = TRUE)

      # Set up parameters to pass to Rmd document
      params <- list(description_population = values$population,
                     description_constraints = values$describe_constraints,
                     collect_entire_population = values$collect_entire_population,
                     effect_of_interest = values$effect_of_interest,
                     minimal_detectable = values$minimal_detectable,
                     expected_effect = values$expected_effect,
                     expected_effect_metric_meta = as.character(values$expected_effect_metric_meta),
                     expected_effect_metric_study = as.character(values$expected_effect_metric_study),
                     expected_effect_value_study = values$expected_effect_value_study,
                     expected_effect_value_meta = values$expected_effect_value_meta,
                     sesoi_effect_metric = as.character(values$sesoi_effect_metric),
                     sesoi_effect_value = values$sesoi_effect_value,
                     statistically_detectable_effect_metric = as.character(values$statistically_detectable_effect_metric),
                     statistically_detectable_effect_value = values$statistically_detectable_effect_value,
                     expected_effect_from_meta = values$expected_effect_from_meta,
                     describe_similarity_meta = values$describe_similarity_meta,
                     describe_homogeneity_meta = values$describe_homogeneity_meta,
                     describe_bias_meta = values$describe_bias_meta,
                     expected_effect_from_study = values$expected_effect_from_study,
                     describe_similarity_study = values$describe_similarity_study,
                     describe_uncertainty_study = values$describe_uncertainty_study,
                     describe_bias_study = values$describe_bias_study,
                     distribution_effect = values$distribution_effect,
                     meta_analysis = values$meta_analysis,
                     decision = values$decision,
                     relative_cost = values$relative_cost,
                     relative_cost_code = values$relative_cost_code,
                     alpha_level = values$alpha_level,
                     power = values$power,
                     effect_size = values$effect_size,
                     effect_metric_1 = as.character(values$effect_metric_1),
                     effect_metric_2 = as.character(values$effect_metric_2),
                     estimate = values$estimate,
                     interval_metric = values$interval_metric,
                     desired_accuracy = values$desired_accuracy,
                     assurance = values$assurance,
                     estimation_code = values$estimation_code,
                     power_goal = values$power_goal,
                     power_type = as.character(values$power_type),
                     power_analysis_code = values$power_analysis_code,
                     observations = values$observations,
                     participants = values$participants,
                     participants_details = values$participants_details,
                     informational_value = values$informational_value)
  
      
      # Knit the document, passing in the `params` list, and eval it in a
      # child of the global environment (this isolates the code in the document
      # from the code in this app).
      rmarkdown::render(tempReport,
        output_file = file,
        params = params,
        envir = new.env(parent = globalenv())
      )
    }
  )
  ###############################################################################
}

# Run the application
shinyApp(ui, server)
