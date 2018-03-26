--Title: TImers and Lives
--Name: Valeria Veverita
--Course: ICS2O
--This program contains a timer that gives the user a certain amount of time to 
--answer the question. It also contains hearts that are lost when the user runs out of 
--time and gets the question wrong.


--hide the status bar 
display.setStatusBar(display.HiddenStatusBar)

--set the background color
local background = display.setDefault("background", 10/255, 20/255, 50/255)

-------------------------------------------------------------------------------------------------------------------------
--LOCAL VARIABLES
-------------------------------------------------------------------------------------------------------------------------

--create loocal variables
local questionObject
local correctObject
local incorrectObject
local numericField
local randomNumber1
local randomNumber2
local userAnswer
local correctAnswer
local randomOperator
local pointsObject 
local points = 0 

--variables for the timer
local totalSeconds = 5
local secondsLeft = 5
local clockText
local countDownTimer

local lives = 5
local heart1
local heart2
local heart3
local heart4

---------------------------------------------------------------------------------------------------------------
--LOCAL FUNCTIONS
---------------------------------------------------------------------------------------------------------------
   
local function AskQuestion()
	-- generate 2 random numbers between a max amd a min number
	randomNumber1 = math.random(0,10)
	randomNumber2 = math.random(0, 10)
	randomOperator = math.random(1,4)
	

    if (randomOperator == 1) then
       correctAnswer = randomNumber1 + randomNumber2
       --create question in text object
        questionObject.text = randomNumber1 .. "+" .. randomNumber2 .. "=" 
    elseif (randomOperator == 2) then
    	correctAnswer = randomNumber1 - randomNumber2 
    	--create qustion in text object
        questionObject.text = randomNumber1 .."-" .. randomNumber2 .. "="

        if ( correctAnswer < 0) then
        	correctAnswer = randomNumber2 - randomNumber1
        	--create question in text object
        	questionObject.text = randomNumber2 .."-" .. randomNumber1 .. "="

        end
    elseif (randomOperator == 3) then
    	correctAnswer = randomNumber1 * randomNumber2 
    	--create qustion in text object
        questionObject.text = randomNumber1 .."*" .. randomNumber2 .. "="
    elseif (randomOperator == 4) then
       correctAnswer = randomNumber1 / randomNumber2
       --create qustion in text object
        questionObject.text = randomNumber1 .."/" .. randomNumber2 .. "="
    end

end

local function HideCorrect()
	correctObject.isVisible = false
	AskQuestion() 
	
end

local function HideIncorrect()
	incorrectObject.isVisible = false
	AskQuestion()
end

local function NumericFieldListener (event)

	--User begin editing "numericField"
	if (event.phase == " began") then


	elseif event.phase == "submitted" then

		--wneh the answer is submitted(enter key is pressed) set user's input to user's answer
        userAnswer = tonumber(event.target.text)

        -- is the user's answer and the correct answer are the same:
        if (userAnswer == correctAnswer) then
            correctObject.isVisible = true
            timer.performWithDelay(2000, HideCorrect)
            --clear the text field

            event.target.text = ""

            points = points + 1 
            pointsObject.text = "Points =" ..points
        else 
        	incorrectObject.isVisible = true
        	timer.performWithDelay(2000, HideIncorrect)
        	--clear the text field
        	event.target.text = ""

        	
        end
    end
end

local function UpdateTime( )
    
    --decrement the number of seconds
    secondsLeft = secondsLeft - 1

    --display the number of seconds left in the clock object
    clockText.text = secondsLeft .. ""

    if (secondsLeft == 0 ) then
    	--reset the number of seconds left
    	secondsLeft = totalSeconds
    	lives = lives - 1

    	--***IF THERE ARE NO LIVES LEFT, PLAY A LOSE SOUND, SHOW A YOU LOSE IMAGE
    	--AND CANCEL TH TIMER REMOVE THE THIRD HEART BU MAKING IT INVISIBLE
    	if (lives==4) then
    		heart2.isVisible = false
    	elseif (lives == 3) then
    		heart1.isVisible = false
    	elseif (lives == 2) then
    		heart3.isVisible = false
    	elseif (lives == 1) then
    		heart4.isVisible = false
    	end

    	--***CALL THE FUNCTION TO ASK A NEW QUESTION
    	AskQuestion()
    end
end

--function that calls the timer
local function StartTimer()
	--create a countdown timer that loops infinitely
	countDownTimer = timer.performWithDelay( 1000, UpdateTime, 0)
end
----------------------------------------------------------------------------------------------------
--OBJECT CREATION
-----------------------------------------------------------------------------------------------------

--displays a question and sets its color
questionObject = display.newText("", display.contentWidth/3, display.contentHeight/2, nil, 50)
questionObject:setTextColor(255/255, 195/255, 0/255)

--displays a question and sets its color
pointsObject = display.newText("Points = 0",150, 50, nil, 50)
pointsObject:setTextColor(255/255, 195/255, 0/255)

---create the correct text object and makes it invisible
correctObject = display.newText("Correct!", display.contentWidth/2, display.contentHeight*2/3, nil, 50)
correctObject:setTextColor(255/255, 195/255, 0/255)
correctObject.isVisible = false

--create the correct text object and makes it invisible
incorrectObject = display.newText("Incorrect!", display.contentWidth/2, display.contentWidth*2/3, nil, 50)
incorrectObject:setTextColor(255/255, 195/255, 0/255)
incorrectObject.isVisible = false
--create numeric field
numericField = native.newTextField( display.contentWidth/2, display.contentHeight/2, 150, 80)
numericField.inputType = "number"

--create the first live
heart1 = display.newImageRect("Images/heart.png", 100, 100)
heart1.x = display.contentWidth * 5/8
heart1.y = display.contentHeight * 1 / 7

--create the second live
heart2 = display.newImageRect("Images/heart.png", 100, 100)
heart2.x = display.contentWidth * 4 /8
heart2.y = display.contentHeight * 1 / 7

--create the second live
heart3 = display.newImageRect("Images/heart.png", 100, 100)
heart3.x = display.contentWidth * 6 /8
heart3.y = display.contentHeight * 1 / 7

--create the second live
heart4 = display.newImageRect("Images/heart.png", 100, 100)
heart4.x = display.contentWidth * 7 /8
heart4.y = display.contentHeight * 1 / 7

--create the timer text
clockText = display.newText("", 500, 600, nil, 150)
clockText:setTextColor(255/255, 195/255, 0/255)
--add the event listener to the numeric field
numericField:addEventListener("userInput", NumericFieldListener)

---------------------------------------------------------------------------------------------------------------
--FUNCTION CALLS
---------------------------------------------------------------------------------------------------------------

--call the function to ask the question
AskQuestion()
StartTimer()