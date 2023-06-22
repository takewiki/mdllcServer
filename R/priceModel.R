#' 查询价格查询注册函数
#'
#' @param input 输入
#' @param output 输出 
#' @param session 会话
#' @param dms_token 口令
#'
#' @return
#' @export
#'
#' @examples
#' priceModelServer()
priceModelServer <- function(input, output, session, dms_token) {
  
  var_txt_priceModel_chartNo <- tsui::var_text('txt_priceModel_chartNo')
  shiny::observeEvent(input$btn_priceModel_query,{
    FChartNumber = var_txt_priceModel_chartNo()
    if(FChartNumber ==''){
      sql <- paste0("
      SELECT [FNumber] as 物料编码
      ,[FChartNumber] 图号
      ,[FMaterialName] 物料名称
      ,[FModel] 规格型号
      ,[FUnit] 计量单位
      ,[FPrice] 采购单价
      ,[FDate] 单据日期
      ,[FDataSource] 单据类型
      ,[FBillNo] 单据编号
  FROM [rds_lc_vw_purchasePriceAll] ")
    }else{
      sql <- paste0("
      SELECT [FNumber] as 物料编码
      ,[FChartNumber] 图号
      ,[FMaterialName] 物料名称
      ,[FModel] 规格型号
      ,[FUnit] 计量单位
      ,[FPrice] 采购单价
      ,[FDate] 单据日期
      ,[FDataSource] 单据类型
      ,[FBillNo] 单据编号
  FROM [rds_lc_vw_purchasePriceAll] 
  where FChartNumber ='",FChartNumber,"'
                    ")
    }
    data = tsda::sql_select2(token = dms_token,sql = sql)
    #显示数据
    tsui::run_dataTable2(id = 'dt_priceModel',data = data)
    #下载数据
    tsui::run_download_xlsx(id = 'dl_priceModel',data = data,filename = '采购价格综合查询.xlsx')
    
    
    
  } )
  

}