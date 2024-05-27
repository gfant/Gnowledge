// This part of the realm is for all the functions that'll show the
// content of the realm in the gno.land website

package stackovergnotools

import (
	"time"

	ufmt "gno.land/p/demo/ufmt"
)

func ReadFormattedQuestion(q Question) string {
	var output string
	output += ufmt.Sprintf(`<div style="display:flex; flex-direction:row; align-items: center;"><div style="border: 1px solid white; padding: 10px; width: fit-content"> 
	%d
  </div> <p style="padding-left:10px">%s</p></div>
<p><small>by %s, on %s</small></p>`, q.Score, q.Question, q.Author.String(), q.CreatedOn.Format(time.RFC822))
	return output
}
