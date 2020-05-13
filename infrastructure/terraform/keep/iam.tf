# IAM groups
## admin

resource "aws_iam_group" "admin" {
  name = "admin"
  path = "/admin/"
}

resource "aws_iam_group_membership" "admin" {
  name = "admin"

  users = [
    aws_iam_user.me.name,
  ]

  group = aws_iam_group.admin.name
}

# IAM policies
## admin

resource "aws_iam_group_policy" "admin" {
  name  = "admin"
  group = aws_iam_group.admin.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

# IAM users
## me

resource "aws_iam_user" "me" {
  name = "sthompson22"
  path = "/admin/"
}
