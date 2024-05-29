// This part of the realm is for all the functions that'll show the
// content of the realm in the gno.land website

package gnowledgetools

import (
	"strconv"
	"time"

	avl "gno.land/p/demo/avl"

	ufmt "gno.land/p/demo/ufmt"
)

//////////////////// Questions ////////////////////

func ReadFormattedQuestion(q Question) string {
	var output string
	output += ufmt.Sprintf(`<div style="display:flex; flex-direction:row; align-items: center;"><div style="border: 1px solid white; padding: 10px; width: fit-content"> 
	%d
  </div> <p style="padding-left:10px">%s</p></div>
<p><small>by <a href="/r/dev/stackovergno:%s">%s</a>, on %s</small></p>`, q.Score, q.Question, q.Author.String(), q.Author.String(), q.CreatedOn.Format(time.RFC822))
	if q.Answers.Size() > 0 {
		number := strconv.Itoa(q.Answers.Size())
		output += ufmt.Sprintf("<p>%s answers<p>", number)
		output += ReadAllAnswers(q.Answers)
	}
	return output
}

func ReadPreviewQuestion(qId int, q Question) string {
	var output string
	output += ufmt.Sprintf(`<a href="/r/dev/stackovergno:%d"><div style="display:flex; flex-direction:row; align-items: center;"><div style="border: 1px solid white; padding: 10px; width: fit-content"> 
	%d
  </div> <p style="padding-left:10px">%s</p></div></a>
<p><small>by <a href="/r/dev/stackovergno:%s">%s</a>, on %s</small></p>`, qId, q.Score, q.Question, q.Author.String(), q.Author.String(), q.CreatedOn.Format(time.RFC822))
	return output
}

func ReadAllQuestionPreviews(tree avl.Tree) string {
	var output string
	tree.Iterate("", "", func(key string, valueInterface interface{}) bool {
		value := valueInterface.(Question)
		qId, ok := strconv.Atoi(key)
		if ok != nil {
			panic(ok)
		}
		output += ReadPreviewQuestion(qId, value) + "\n<hr/>"
		return false
	})
	return output
}

func ReadPreviewAnswer(answer Answer) string {
	var output string
	output += ufmt.Sprintf(`<hr/><p><%d> %s</p>
	<p><small>by <a href="/r/dev/stackovergno:%s">%s</a>, on %s</small></p>`, answer.Score, answer.response, answer.Author, answer.Author, answer.CreatedOn)
	return output
}

func ReadAllAnswers(answersTree avl.Tree) string {
	var output string
	answersTree.Iterate("", "", func(key string, valueInterface interface{}) bool {
		value := valueInterface.(Answer)
		output += ReadPreviewAnswer(value) + "\n"
		return false
	})
	return output
}

//////////////////// User profiles ////////////////////

// Get the information of a given address
func ReadUser(site avl.Tree, addr string) string {
	userInterface, ok := site.Get(addr)
	if !ok {
		return ""
	}
	user := userInterface.(Data)
	userContent := outputInformation(user)
	return userContent
}

// Stringifies the output
// Based on future enhacements of realm output can be edited
func outputInformation(user Data) string {
	var output string
	experience := ""
	for _, e := range user.Experience {
		experience += readJobExperience(e)
	}

	networks := readNetworks(user.Networks)
	networkTitle := ""
	if networks != "" {
		networkTitle = "## Networks"
	}
	output += ufmt.Sprintf(`# %s
<center>%s</center>
<center>(%s)</center>

%s
%s

## Experience
%s`, user.Name, user.Description, user.Location, networkTitle, networks, experience)
	return output
}

func readJobExperience(content JobExperience) string {
	working := ""
	if content.Current == true {
		working = "(c)"
	}
	output := ufmt.Sprintf(`### >> %s at %s %s
<code> (%s-%s) %s </code>
#### About the job
%s

`, content.Title, content.Company, working, content.StartDate, content.EndDate, content.EmploymentType, content.Description)
	return output
}

func readNetworks(networks avl.Tree) string {
	output := ""
	networks.Iterate("", "", func(key string, value interface{}) bool {
		output += ufmt.Sprintf("[%s](%s)\n\n", key, value)
		return false
	})
	return output
}
