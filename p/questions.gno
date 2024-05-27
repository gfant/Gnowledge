// The cornerstone of the realm

package stackovergnotools

import (
	"std"
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
}

func NewQuestion(question string, topics []string) Question {
	newQ := Question{
		Question:  question,
		Score:     1,
		Author:    std.GetOrigCaller(),
		Topics:    topics,
		CreatedOn: time.Now(),
	}
	return newQ
}
