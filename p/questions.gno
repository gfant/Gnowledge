// The cornerstone of the realm

package gnowledgetools

import (
	"std"
	"strconv"
	"time"

	ufmt "gno.land/p/demo/ufmt"

	avl "gno.land/p/demo/avl"
)

type Question struct {
	Question  string      // Question made
	Score     int         // Score of the question
	Author    std.Address // Author of the question
	Topics    []string    // Topics that relate to the question. This can be removed by consensus by other users
	CreatedOn time.Time   // Date of creaton
	Answers   avl.Tree    // Answers of other members
	AnswersId int         // Answers of other members
}

type Answer struct {
	response  string      // content of answer
	Score     int         // Score of the answer
	Author    std.Address // Author of the answer
	CreatedOn time.Time   // Date of creaton
}

func NewQuestion(question string, topics []string) Question {
	newQ := Question{
		Question:  question,
		Score:     1,
		AnswersId: 1,
		Author:    std.GetOrigCaller(),
		Answers:   avl.Tree{},
		Topics:    topics,
		CreatedOn: time.Now(),
	}
	return newQ
}

func (q Question) AnswerQuestion(response string) {
	newAnswer := Answer{
		response:  response,
		Author:    std.GetOrigCaller(),
		CreatedOn: time.Now(),
		Score:     1,
	}
	aId := strconv.Itoa(q.AnswersId)
	q.Answers.Set(aId, newAnswer)
}
