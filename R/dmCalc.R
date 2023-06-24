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
dmCalcServer <- function(input, output, session, dms_token) {
  #同步数据
  shiny::observeEvent(input$btn_dmCalc_sync,{
    lcrdspkg::dmList_toODSBatch(dms_token = dms_token)
    tsui::pop_notice(msg = '完成DM数据同步！')
  })
  #DM所有单进行成本
  shiny::observeEvent(input$btn_dmCalc_all,{
    lcrdspkg::priceModel_DmCalcAll(dms_token = dms_token)
    tsui::pop_notice(msg = '完成DM成本卷算！')
  })
  
  var_txt_dmCalc_chartNo = tsui::var_text('txt_dmCalc_chartNo')
  
  shiny::observeEvent(input$btn_dmCalc_one,{
    FDmNo = var_txt_dmCalc_chartNo()
    lcrdspkg::priceModel_DmCalcOne(dms_token = dms_token,FDmNo = FDmNo)
    tsui::pop_notice(msg = paste0(FDmNo,'完成DM成本卷算！'))
    
  })
  
  
  
}