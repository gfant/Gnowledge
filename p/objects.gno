// This part of the realm is for all the functions that'll show the
// content of the realm in the gno.land website

package gnowledgetools

import (
	"strconv"
	"strings"
	"time"

	avl "gno.land/p/demo/avl"

	ufmt "gno.land/p/demo/ufmt"
)

func JSONQuestion(q Question, id string) string {
	topics := "[" + strings.Join(q.Topics, ",") + "]"
	json := ufmt.Sprintf(`
	{"question":"%s",
	"score":%d,
	"author":"%s",
	"createdOn":"%s",
	"id":"%s",
	"topics":"%s"}`, q.Question, q.Score, q.Author, q.CreatedOn.Format(time.RFC822), id, topics)

	return json
}

func JSONAnswer(a Answer) string {
	json := ufmt.Sprintf(`
	{"response":"%s",
	"score":%d,
	"author":"%s",
	"createdOn":"%s"}
	`, a.Response, a.Score, a.Author, a.CreatedOn.Format(time.RFC822))

	return json
}

func JSONData(d Data) string {
	networks := JSONNetworks(d.Networks)
	skills := JSONSkills(d.Skills)
	json := ufmt.Sprintf(`
	"response":"%s",
	"Name":"%s",               
	"NickName":"%s",           
	"Location":"%s",           
	"Description":"%s",        
	"Connections":"%s",        
	"Experience":"%s",         
	"Skills": "%s",             
	"Networks":"%s"}
	`, d.Name, d.NickName, d.Location, d.Description, d.Experience, skills, networks)

	return json
}

func JSONNetworks(n avl.Tree) string {
	json := "{"
	n.Iterate("", "", func(network string, value interface{}) bool {
		link := value.(string)
		json += ufmt.Sprintf(`"%s":"%s",`, network, link)
		return false
	})
	json += "}"
	return json
}

func JSONSkills(s avl.Tree) string {
	json := ""
	s.Iterate("", "", func(skill string, value interface{}) bool {
		// Temporarily removing the association of skill with job
		// job := value.(string)
		// json += ufmt.Sprintf(`"%s":"%s",`, skill, job)
		json += ufmt.Sprintf(`"%s,"`)
		return false
	})
	json = json[:len(json)-1] // Removing last comma
	return json
}
