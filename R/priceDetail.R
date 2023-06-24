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
#' priceDetailServer()
priceDetailServer <- function(input, output, session, dms_token) {

  
  var_txt_priceDetail_chartNo = tsui::var_text('txt_priceDetail_chartNo')
  
  shiny::observeEvent(input$btn_priceDetail_one,{
    FDmNo = var_txt_priceDetail_chartNo()
    data = lcrdspkg::priceDetail_query(dms_token = dms_token,FDmNo = FDmNo)
    tsui::run_dataTable2(id = 'dt_priceDetail',data = data)
    tsui::run_download_xlsx(id = 'dl_priceDetail',data = data,filename = 'DM核价明细表.xlsx')
    
  })
  
  
  
}