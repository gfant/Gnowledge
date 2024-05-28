package stackovergno

import (
	"std"
	"strconv"
	"strings"

	ufmt "gno.land/p/demo/ufmt"

	avl "gno.land/p/demo/avl"

	stackovergnotools "gno.land/p/dev/stackovergnotools"
)

// Register yourself in the realm
func Register() {
	caller := std.GetOrigCaller().String()
	site.Set(caller, stackovergnotools.Data{})
}

func ReadUser(address string) string {
	output := stackovergnotools.ReadUser(site, address)
	return output
}

func AddJob(current, Title, EmploymentType, Company, Location, StartDate, EndDate, JobDescription string) {
	stackovergnotools.AddJob(current, Title, EmploymentType, Company, Location, StartDate, EndDate, JobDescription, site)
}

func AddNetwork(network, path string) {
	stackovergnotools.AddNetwork(network, path, site)
}
