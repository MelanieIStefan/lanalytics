#' @title Item Characteristic Curve ICC
#' 
#' @description This function computes a graph of the ICC of the Rasch model
#'
#' @param quiz_object Receives as input the dataframe un long format of all quizzes (Generated with read_lc)
#'
#' @return A plot of the ICC
#'
#' @examples
#' file_to_read <- "../../datasets/sample_dataset/Q01.csv"
#' quiz_object <- read_lc(file_to_read)
#' plot_jointICC(quiz_object)
#' @export
plot_jointICC <- function(quiz_object){
  data_tibble <- quiz_object %>% 
    ungroup() %>% 
    dplyr::select(`email address`, question, score) %>% 
    tidyr::spread(question, score, fill = 0) %>% 
    dplyr::select(-`email address`) %>% 
    stats::setNames(paste("item", names(.))) %>% 
    purrr::map_if(is.character, as.numeric) %>% 
    tibble::as_tibble() %>% 
    purrr::discard(~sum(.)<03) %>% 
    purrr::discard(~sum(.)>97) %>% as.matrix()
  
  model <- RM(data_tibble)
  plotjointICC(model, xlim = c(-8, 5))
}  