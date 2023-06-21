#' 处理逻辑
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
#' dateServer()
dateServer <- function(input,output,session,dms_token) {


  var_date_orderDate = tsui::var_date('date_orderDate')
  shiny::observeEvent(input$btn_dateShow,{

    #code here:
   value_date = var_date_orderDate()

   output$date_res <- shiny::renderPrint({
     value_date
   })





  })












}
