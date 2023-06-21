#' 测试数据
#'
#' @param dms_token 口令
#'
#' @return 返回测试数据集
#' @export
#'
#' @examples
#' test_query()
test_query <- function(dms_token) {

  sql <- paste0("SELECT TOP (10) [fname]
      ,[fage]
  FROM  [t_test]")
  data = tsda::sql_select2(token = dms_token,sql = sql)
  return(data)

}

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
#' demoServer()
demoServer <- function(input,output,session,dms_token) {


shiny::observeEvent(input$btn_action2,{
  print(1)
  data = test_query(dms_token = dms_token)
  print(data)
  tsui::run_dataTable2(id = 'dt_res',data = data)
})







}
