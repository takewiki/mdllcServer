#' DM单计算
#'
#' @param input 输入
#' @param output 输出 
#' @param session 会话
#' @param dms_token 口令
#'
#' @return 返回值
#' @export
#'
#' @examples
#' dmCalcServer()
priceSummaryServer <- function(input, output, session, dms_token) {
  shiny::observeEvent(input$btn_priceSummary_one,{
   
    data = lcrdspkg::priceSummary_query(dms_token = dms_token)
    tsui::run_dataTable2(id = 'dt_priceSummary',data = data)
    tsui::run_download_xlsx(id = 'dl_priceSummary',data = data,filename = 'DM核价汇总表.xlsx')
    
  })
  
  
}