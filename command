#!/bin/bash
if [ $# -eq 0 ] || [ ! -f "$1" ]; then
    echo "Report location not provided, or file not found for upload."
    
    if [ ! -f "$1" ]; then
    	echo "(Report location provided: $1)"
    fi
    
    # Special casing here is in response to non-trivial performance implementations scanning an entire build workspace for candidate files
    
    #Gradle default location is in the build folder
    if [ -d "./build" ]; then
    	echo "Suggestions:"
    	find ./build -name '*_bdio.jsonld' -print
    fi
    
    #Maven default is in a target folder
    if [ -d "./target" ]; then
    	echo "Suggestions:"
    	find ./target -name '*_bdio.jsonld' -print
    fi
    
    exit 1
fi

#Log that the script download is complete and proceeding
echo "Uploading report at $1"

#Log the curl version used
curl --version

#Environment variables used here are documented at https://docs.travis-ci.com/user/environment-variables/#Default-Environment-Variables
curl -v -f -X POST -d @$1 -H 'Content-Type:application/ld+json' "https://copilot.blackducksoftware.com/hub/import?provider=github&repository=$TRAVIS_REPO_SLUG&branch=$TRAVIS_BRANCH&pull_request=$TRAVIS_PULL_REQUEST"

#Exit with the curl command's output status
exit $?