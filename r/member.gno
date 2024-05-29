package stackovergno

import (
	"std"
	"strconv"
	"strings"

	ufmt "gno.land/p/demo/ufmt"

	avl "gno.land/p/demo/avl"

	gnowledgetools "gno.land/p/dev/gnowledgetools"
)

// Register yourself in the realm
func Register() {
	caller := std.GetOrigCaller().String()
	site.Set(caller, gnowledgetools.Data{})
}

func ReadUser(address string) string {
	output := gnowledgetools.ReadUser(site, address)
	return output
}

func AddJob(current, Title, EmploymentType, Company, Location, StartDate, EndDate, JobDescription string) {
	gnowledgetools.AddJob(current, Title, EmploymentType, Company, Location, StartDate, EndDate, JobDescription, site)
}

func AddNetwork(network, path string) {
	gnowledgetools.AddNetwork(network, path, site)
}
