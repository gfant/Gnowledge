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
	NoQuestionId     = "No Question with given Id"
	ErrRegisterFirst = "Register First!"
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
		output += ReadProfile(mainPart)
		return output
	}
	// TODO: Add a default website
	return "Add more"
}

// Register yourself in the realm
func Register() {
	caller := std.GetOrigCaller().String()
	site.Set(caller, stackovergnotools.Data{})
}

// Add a job experience for yourself
// The order will be done by the website
func AddJob(current string, Title string, EmploymentType string, Company string, Location string, StartDate string, EndDate string, JobDescription string) {
	caller := std.GetOrigCaller().String()
	userDataInterface, ok := site.Get(caller)
	if !ok {
		panic(ErrRegisterFirst)
	}
	userData := userDataInterface.(Data)
	actual := false
	if current != "" {
		actual = true
	}
	newJob := GenerateJobExperience(actual, Title, EmploymentType, Company, Location, StartDate, EndDate, JobDescription)
	Experience := append(userData.Experience, newJob)
	userData.Experience = Experience
	site.Set(caller, userData)
}

func AddNetwork(network, path string) {
	caller := std.GetOrigCaller().String()
	userInterface, ok := site.Get(caller)
	if !ok {
		panic(ErrNoData)
	}
	user := userInterface.(Data)
	updateNetwork(user, network, path)
}

func MakeQuestion(question, topics string) int {
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

func ReadProfile(address string) string {
	// TODO: Combine with gnokedin realm
	return "fancy Prof"
}
