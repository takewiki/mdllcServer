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
#' buttonactionServer()
buttonactionServer <- function(input,output,session,dms_token) {
  #一般按纽,用于计数器显示
  shiny::observeEvent(input[['btn_shiny']],{
    #获取按纽获取的值
    value = as.character(as.integer(input[['btn_shiny']]))
    #更新字符串的值
    output[['ui_shinyButton']] <- shiny::renderUI({
      tsui::mdl_text(id = 'txt_shinyButton',label = '显示btn_shiny结果',value = value)
    })
  })
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
#' buttonAutoRefreshServer()
buttonAutoRefreshServer <- function(input,output,session,dms_token) {
  autoRefresh <-shiny::reactiveTimer()

  shiny::observe({

    autoRefresh()
    shiny::updateActionButton(session = session,inputId = 'btn_shinyWidgets',label = tsdo::getTime())

  })
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
#' buttonAutoRefreshServer()
buttonDownloadServer <- function(input,output,session,dms_token) {

  #下载测试数据
  data = test_query(dms_token = dms_token)
  tsui::run_download_xlsx(id = 'dl_data',data = data,filename = '测试数据.xlsx')
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
#' buttonServer()
buttonServer <- function(input,output,session,dms_token) {
  #演示功用1
  buttonactionServer(input,output,session,dms_token)
  #演示功能2
  buttonAutoRefreshServer(input,output,session,dms_token)
  #下载演示数据
  buttonDownloadServer(input,output,session,dms_token)















}
