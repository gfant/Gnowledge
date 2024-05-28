package stackovergno

import (
	"std"
	"strconv"
	"strings"

	ufmt "gno.land/p/demo/ufmt"

	avl "gno.land/p/demo/avl"

	stackovergnotools "gno.land/p/dev/stackovergnotools"
)

// Errors for commands
var (
	NoQuestionId = "No Question with given Id"
)

// Variables to use in the realm
var (
	QuestionsCounter int
	Questions        avl.Tree
	LastestQuestions []stackovergnotools.Question
	// TopRatedQuestions PriorityQueue of Questions
	site avl.Tree // Stores all the users in the realm
)

func init() {
	Questions = avl.Tree{}
	site = avl.Tree{}
	LastestQuestions = []stackovergnotools.Question{}
	QuestionsCounter++
}

func Render(path string) string {
	var output string
	parts := strings.Split(path, "/")
	mainPart := parts[0]
	if _, ok := strconv.Atoi(mainPart); ok == nil {
		output += ReadQuestionById(mainPart)
		return output
	}
	candidateAddress := std.Address(mainPart)
	if len(candidateAddress) == 40 {
		output += ReadUser(mainPart)
		return output
	}
	// TODO: Add a default website
	return ufmt.Sprintf("%d", Questions.Size())
}

func MakeQuestion(question, topics string) int {
	caller := std.GetOrigCaller().String()
	_, ok := site.Get(caller)
	if !ok {
		panic(stackovergnotools.ErrRegisterFirst)
	}
	topicsArr := strings.Split(topics, ",")
	q := stackovergnotools.NewQuestion(question, topicsArr)
	questionCounterString := strconv.Itoa(QuestionsCounter)
	Questions.Set(questionCounterString, q)
	QuestionsCounter++
	return QuestionsCounter
}

func ReadQuestionById(id string) string {
	qInterface, ok := Questions.Get(id)
	if !ok {
		panic(NoQuestionId)
	}
	q := qInterface.(stackovergnotools.Question)
	questionText := stackovergnotools.ReadFormattedQuestion(q)
	return questionText
}
