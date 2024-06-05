package gnowledge

import (
	ufmt "gno.land/p/demo/ufmt"

	avl "gno.land/p/demo/avl"

	gnowledgetools "gno.land/p/dev/gnowledgetools"
)

func jsonAllQuestions(qs avl.Tree) string {
	var json string
	qs.Iterate("", "", func(qId string, qInterface interface{}) bool {
		q := qInterface.(gnowledgetools.Question)
		qJSON := gnowledgetools.JSONQuestion(q, qId)
		json += ufmt.Sprintf(`"%s":%s,`, qId, qJSON)
		return false
	})
	json = json[:len(json)-1]
	json = "{" + json + "}"
	return json
}

func jsonAllAnswers(q gnowledgetools.Question) string {
	var json string
	q.Answers.Iterate("", "", func(aId string, qInterface interface{}) bool {
		a := qInterface.(gnowledgetools.Answer)
		aJSON := gnowledgetools.JSONAnswer(a)
		json += ufmt.Sprintf(`"%s":%s,`, aId, aJSON)
		return false
	})
	json = json[:len(json)-1]
	json = "{" + json + "}"
	return json
}
