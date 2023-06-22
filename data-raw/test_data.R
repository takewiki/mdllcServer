library(readxl)
file_name = "data-raw/采购调价表 (1).xlsx"


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