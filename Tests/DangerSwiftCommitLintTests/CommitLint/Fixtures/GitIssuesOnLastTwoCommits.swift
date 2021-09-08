let gitIssuesOnLastTwoCommitsJSON = """
{
    "modified_files": [
        "Tests/SampleTest.swift"
    ],
    "created_files": [],
    "deleted_files": [],
    "commits": [
        {
            "sha": "testshacommit4",
            "author": {
                "name": "Test Testy",
                "email": "test.testy@mock.test",
                "date": "2021-09-08T23:16:13.000Z"
            },
            "committer": {
                "name": "Test Testy",
                "email": "test.testy@mock.test",
                "date": "2019-04-10T21:56:43.000Z"
            },
            "message": "Hi",
            "parents": [],
            "url": "https://gitlab.com/test/test.systems/commit/testshacommit4",
            "tree": null
        },
        {
            "sha": "testshacommit3",
            "author": {
                "name": "Test Testy",
                "email": "test.testy@mock.test",
                "date": "2021-09-08T21:56:43.000Z"
            },
            "committer": {
                "name": "Test Testy",
                "email": "test.testy@mock.test",
                "date": "2019-04-10T21:56:43.000Z"
            },
            "message": "subject for test purpose - commit 3 very very long commit subject.\\nTest Body Line 1.\\nTest Body Line 2.",
            "parents": [],
            "url": "https://gitlab.com/test/test.systems/commit/testshacommit3",
            "tree": null
        },
        {
            "sha": "testshacommit2",
            "author": {
                "name": "Test Testy",
                "email": "test.testy@mock.test",
                "date": "2021-09-08T20:10:33.000Z"
            },
            "committer": {
                "name": "Test Testy",
                "email": "test.testy@mock.test",
                "date": "2019-04-10T20:10:33.000Z"
            },
            "message": "Merge branch 'master' into TestRepository/tt/tech-123-update-sample-test",
            "parents": [],
            "url": "https://gitlab.com/test/test.systems/commit/testshacommit2",
            "tree": null
        },
        {
            "sha": "testshacommit1",
            "author": {
                "name": "Test Testy",
                "email": "test.testy@mock.test",
                "date": "2021-09-08T16:23:31.000Z"
            },
            "committer": {
                "name": "Test Testy",
                "email": "test.testy@mock.test",
                "date": "2019-04-10T16:23:31.000Z"
            },
            "message": "Subject for test purpose - commit 1\\n\\nTest Body Line 1.\\nTest Body Line 2.",
            "parents": [],
            "url": "https://gitlab.com/test/test.systems/commit/testshacommit1",
            "tree": null
        }
    ]
}
"""
