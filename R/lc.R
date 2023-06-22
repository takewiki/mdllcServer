



#' Title 预览数据
#'
#' @param input 输入
#' @param output 输出
#' @param session 会话
#' @param dms_token 口令
#'
#' @return 返回值
#' @export
#'
#' @examples viewserver()
viewserver <- function(input, output, session, dms_token) {
  var_file_export_baseInfo = tsui::var_file('uploadfile')
  

    shiny::observeEvent(input$btn_view,
                        {
                          # 获取文件路径
                          file_name = var_file_export_baseInfo()
                          #由于数据类型的问题,因此需要添加数据类型转换
                          data_excel <-
                            readxl::read_excel(
                              file_name,
                              col_types = c(
                                "numeric",
                                "text",
                                "text",
                                "text",
                                "text",
                                "text",
                                "text",
                                "text",
                                "text",
                                "text",
                                "text"
                              )
                              
                            )
                          data_excel$`原价格` <- as.numeric(data_excel$`原价格`)
                          data_excel$`用铜量(KG)` <- as.numeric(data_excel$`用铜量(KG)`)
                          data_excel$`原铜价基准` <- as.numeric(data_excel$`原铜价基准`)
                          data_excel$`现基准铜价` <- as.numeric(data_excel$`现基准铜价`)
                          data_excel$`现价格` <- as.numeric(data_excel$`现价格`)
                          data_excel$`涨价` <- as.numeric(data_excel$`涨价`)
                          
                          
                          data_excel = as.data.frame(data_excel)
                          
                          data_excel = tsdo::na_standard(data_excel)
                          data_excel$FUploadDate = tsdo::getDate()
                          
                          #显示数据
                          tsui::run_dataTable2(id = 'view_data', data = data_excel)
                          
                        })

}


#' Title 上传数据
#'
#' @param input 输入
#' @param output 输出
#' @param session 会话
#' @param dms_token 口令
#'
#' @return 返回值
#' @export
#'
#' @examples uploadserver()
uploadserver <- function(input, output, session, dms_token) {
  var_file_export_baseInfo = tsui::var_file('uploadfile')
  
  shiny::observeEvent(input$btn_upload,
                      {
                        # 获取文件路径
                        file_name = var_file_export_baseInfo()
                        
                        data_excel <-
                          readxl::read_excel(
                            file_name,
                            col_types = c(
                              "numeric",
                              "text",
                              "text",
                              "text",
                              "text",
                              "text",
                              "text",
                              "text",
                              "text",
                              "text",
                              "text"
                            )
                            
                          )
                        data_excel$`原价格` <- as.numeric(data_excel$`原价格`)
                        data_excel$`用铜量(KG)` <- as.numeric(data_excel$`用铜量(KG)`)
                        data_excel$`原铜价基准` <- as.numeric(data_excel$`原铜价基准`)
                        data_excel$`现基准铜价` <- as.numeric(data_excel$`现基准铜价`)
                        data_excel$`现价格` <- as.numeric(data_excel$`现价格`)
                        data_excel$`涨价` <- as.numeric(data_excel$`涨价`)
                        
                        data_excel = as.data.frame(data_excel)
                        
                        data_excel = tsdo::na_standard(data_excel)
                        
                        
                        columnsname = c('物料号',	'描述', '线型',	'单位', '现价格')
                        data_excel = data_excel[, columnsname]
                        data_excel$FUploadDate = tsdo::getDate()
                        
                        names(data_excel) = c('FmaterialId',
                                              'FmaterialName',
                                              'FLineModel',
                                              'FUnit',
                                              'FPrice',
                                              'FUploadDate')
                        print('bug1')
                        
                        # 写入中间表
                        tsda::db_writeTable2(
                          token = dms_token,
                          table_name = 'rds_lc_src_purchase_priceAdjustment_input',
                          r_object = data_excel,
                          append = TRUE
                        )
                        
                        # 删除中间表中已存在与src的物料
                        dsql = 'delete a from rds_lc_src_purchase_priceAdjustment_input  a inner join rds_lc_src_purchase_priceAdjustment b On a.FmaterialId=b.FmaterialId and a.FUploadDate =b.FUploadDate'
                        tsda::sql_update2(token = dms_token, sql_str = dsql)
                        
                        # 中间表插入src，保留所有日期单价
                        isql = 'insert into rds_lc_src_purchase_priceAdjustment  select * from rds_lc_src_purchase_priceAdjustment_input'
                        tsda::sql_insert2(token = dms_token, sql_str = isql)
                        
                        # 清空中间表
                        dsql = 'truncate table rds_lc_src_purchase_priceAdjustment_input'
                        tsda::sql_update2(token = dms_token, sql_str = dsql)
                        
                        # 保留最新日期单价,删除ods中存在于最新价格表的数据
                        odsdsql = 'delete a from rds_lc_ods_purchase_priceAdjustment a inner join rds_lc_vw_purchase_priceAdjustment_latest b On a.FmaterialId=b.FmaterialId'
                        tsda::sql_update2(token = dms_token, sql_str = odsdsql)
                        
                        # 将最新数据插入ods
                        odsisql = 'insert into rds_lc_ods_purchase_priceAdjustment  select * from rds_lc_vw_purchase_priceAdjustment_latest'
                        tsda::sql_insert2(token = dms_token, sql_str = odsisql)
                        
                        tsui::pop_notice('数据上传成功')
                        
                        
                      })
}


#' Title 下载日志
#'
#' @param input 输入
#' @param output 输出
#' @param session 会话
#' @param dms_token 口令
#'
#' @return 返回值
#' @export
#'
#' @examples downloadserver()
downloadserver <- function(input, output, session, dms_token) {
  
  
  var_txt_purchasePriceAdj_chartNo <- tsui::var_text('txt_purchasePriceAdj_chartNo')
  shiny::observeEvent(input$btn_purchaseAdj_query,{
    FChartNumber = var_txt_purchasePriceAdj_chartNo()
    if(FChartNumber==''){
      sql =  paste0("SELECT [FmaterialId]  as 图号
      ,[FmaterialName] as 物料名称
      ,[FLineModel]  as 规格型号
      ,[FUnit] as 计量单位
      ,[FPrice]  as  采购价
      ,[Fupdatetime] as 调价日期
  FROM [rds_lc_ods_purchase_priceAdjustment]")
    }else{
      sql =  paste0("SELECT [FmaterialId]  as 图号
      ,[FmaterialName] as 物料名称
      ,[FLineModel]  as 规格型号
      ,[FUnit] as 计量单位
      ,[FPrice]  as  采购价
      ,[Fupdatetime] as 调价日期
  FROM [rds_lc_ods_purchase_priceAdjustment]
  where FmaterialId = '",FChartNumber,"'
                    ")
    }
    
    
    print(sql)
    #查询到调价单数据
    data = tsda::sql_select2(dms_token, sql)
    #
    #显示数据
    tsui::run_dataTable2(id = 'view_data', data = data)
    #下载数据
    
    tsui::run_download_xlsx(id = 'btn_download',
                            data = data ,
                            filename = '最新采购调价单.xlsx')
    
  })
  
  
  
}



#' Title 后台处理总函数
#'
#' @param input 输入
#' @param output 输出
#' @param session 会话
#' @param dms_token 口令
#'
#' @return 返回值
#' @export
#'
#' @examples HrvServer()
lcServer <- function(input, output, session, dms_token) {
  #预览数据
  viewserver(input, output, session, dms_token)
  #上传数据
  uploadserver(input, output, session, dms_token)
  # 下载日志
  downloadserver(input, output, session, dms_token)
}