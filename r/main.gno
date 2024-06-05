package gnowledge

import (
	"std"
	"strconv"
	"strings"

	ufmt "gno.land/p/demo/ufmt"

	avl "gno.land/p/demo/avl"

	gnowledgetools "gno.land/p/dev/gnowledgetools"
)

// Errors for commands
var (
	NoQuestionId    = "No Question with given Id"
	NoAnswerId      = "No Answer with given Id"
	InvalidAction   = "Action not allowed"
	UnexpectedError = "Unexpected Error"
	ErrNoData       = "No data of this user"
)

// Variables to use in the realm
var (
	QuestionsCounter int
	Questions        avl.Tree
	LastestQuestions []gnowledgetools.Question
	// TopRatedQuestions PriorityQueue of Questions
	site avl.Tree // Stores all the users in the realm
)

func init() {
	Questions = avl.Tree{}
	site = avl.Tree{}
	LastestQuestions = []gnowledgetools.Question{}
	QuestionsCounter++
}

func Render(path string) string {
	var output string
	if path == "" {
		output += `<h1>Gnowledge</h1>`
		output += gnowledgetools.ReadAllQuestionPreviews(Questions)
		return output
	}
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
		panic(gnowledgetools.ErrRegisterFirst)
	}
	topicsArr := strings.Split(topics, ",")
	q := gnowledgetools.NewQuestion(question, topicsArr)
	questionCounterString := strconv.Itoa(QuestionsCounter)
	Questions.Set(questionCounterString, q)
	QuestionsCounter++
	return QuestionsCounter
}

func UpvoteQuestion(id int) {
	caller := std.GetOrigCaller()
	idStr := strconv.Itoa(id)
	qInterface, ok := Questions.Get(idStr)
	if !ok {
		panic(NoQuestionId)
	}
	q := qInterface.(gnowledgetools.Question)
	// Can't upvote your own question
	if caller == q.Author {
		panic(InvalidAction)
	}
	q.Score++
	Questions.Set(idStr, q)
}

func DownvoteQuestion(id int) {
	caller := std.GetOrigCaller()
	idStr := strconv.Itoa(id)
	qInterface, ok := Questions.Get(idStr)
	if !ok {
		panic(NoQuestionId)
	}
	q := qInterface.(gnowledgetools.Question)
	// Can't downvote your own question
	if caller == q.Author {
		panic(InvalidAction)
	}
	q.Score--
	Questions.Set(idStr, q)
}

func ReadQuestionById(id string) string {
	qInterface, ok := Questions.Get(id)
	if !ok {
		panic(NoQuestionId)
	}
	q := qInterface.(gnowledgetools.Question)
	questionText := gnowledgetools.ReadFormattedQuestion(q)
	return questionText
}

func AnswerQuestion(response string, questionId string) {
	qInterface, ok := Questions.Get(questionId)
	if !ok {
		panic(NoQuestionId)
	}
	q := qInterface.(gnowledgetools.Question)
	q.AnswerQuestion(response)
	q.AnswersId++
	Questions.Set(questionId, q)
}

func UpvoteAnswer(qId, aId int) {
	caller := std.GetOrigCaller()
	aIdStr := strconv.Itoa(aId)
	qIdStr := strconv.Itoa(qId)
	qInterface, ok := Questions.Get(qIdStr)
	if !ok {
		panic(NoQuestionId)
	}
	q := qInterface.(gnowledgetools.Question)
	aInterface, ok := q.Answers.Get(aIdStr)
	if !ok {
		panic(NoAnswerId)
	}
	a := aInterface.(gnowledgetools.Answer)
	// Can't downvote your own answer
	if caller == a.Author {
		panic(InvalidAction)
	}
	a.Score++
	q.Answers.Set(aIdStr, a)
	Questions.Set(qIdStr, q)
}

func DownvoteAnswer(qId, aId int) {
	caller := std.GetOrigCaller()
	aIdStr := strconv.Itoa(aId)
	qIdStr := strconv.Itoa(qId)
	qInterface, ok := Questions.Get(qIdStr)
	if !ok {
		panic(NoQuestionId)
	}
	q := qInterface.(gnowledgetools.Question)
	aInterface, ok := q.Answers.Get(aIdStr)
	if !ok {
		panic(NoAnswerId)
	}
	a := aInterface.(gnowledgetools.Answer)
	// Can't downvote your own answer
	if caller == a.Author {
		panic(InvalidAction)
	}
	a.Score--
	q.Answers.Set(aIdStr, a)
	Questions.Set(qIdStr, q)
}

func GetQuestions() string {
	qs := jsonAllQuestions(Questions)
	return qs
}

func GetAnswers(qId string) string {
	qInterface, ok := Questions.Get(qId)
	if !ok {
		panic(ErrNoData)
	}
	q := qInterface.(gnowledgetools.Question)
	as := jsonAllAnswers(q)
	return as
}
