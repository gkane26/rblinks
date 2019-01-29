#' Convert MedPC File to an R data table
#'
#' @param file string or vector; complete path to MedPC data file
#' @param group string (optional); experimental group of animal
#' @param condition string (optional); experimental condition (i.e. drug)
#'
#' @return data table with the following variables: \cr
#'  subject \cr
#'  group \cr
#'  condition \cr
#'  date = ddmmyy \cr
#'  trial = trial number \cr
#'  pLeftBlink = p(left blink) on trial \cr
#'  pRightBlink = p(right blink) on trial, 1-p(left blink) \cr
#'  blinkSequence = actual sequence of blinks from start of trial until response \cr
#'  choice = choice on trial; 0=left, 1=right
#'  RT = response time for trial
#'  omission = did rat get reward (only applicable for correct trials)? 0 if yes, 1 if no
#'  rewardRT = response time from decision to reward; 0 if incorrect
#'  startTime = time in session at start of trial
#'  decisionTime = time in session at decision
#'  rewardTime = time in session at reward receipt
#'  trialTime = duration of trial
#'  pCorrectBlink = p(blink) on correct side; p(left blink) if left is correct, p(right blink) if right is correct
#'  correctSide = 0 is left is correct answer, 1 if right is correct answer
#'  correctChoice = 0 if incorrect, 1 if correct
#'
#' @export
med_to_dt <- function(file, group=NA, condition=NA){

  dList = rmedpc::import_medpc(file)

  # fix blink sequences
  blinkSequence = character(dList$I[1])
  for(i in 1:dList$I[1]){
    blinkSequence[i] = paste(dList$N[dList$M == (i - 1)], collapse="")
  }

  #create data table
  dat = data.table(subject=dList$Subject,
                   group=group,
                   condition=condition,
                   date=do.call(paste, as.list(c(strsplit(dList$'Start Date', split="/")[[1]], sep=""))),
                   trial=1:dList$I[1],
                   pLeftBlink=dList$J,
                   pRightBlink=1-dList$J,
                   leftBlinks=dList$K-1,
                   rightBlinks=dList$L-1,
                   blinkSequence=blinkSequence,
                   choice=dList$B,
                   RT=dList$D,
                   omission=dList$C,
                   rewardRT=dList$E,
                   startTime=dList$F,
                   decisionTime=dList$G,
                   rewardTime=dList$H,
                   trialTime=c(diff(dList$F), NA))

  dat[, pCorrectBlink := ifelse(pLeftBlink >= .5, pLeftBlink, pRightBlink)]
  dat[, correctSide := dList$A]
  dat[, correctChoice := ifelse(choice==correctSide, 1, 0)]

  return(dat)
}
