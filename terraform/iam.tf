# -------------------------------------------------------------------------------------
#MASTER ROLE--------------------------------------------------------------------------
# -----------------------------------------------------------------------------------

resource "aws_iam_role" "master_role" {
  name = "wanderlust-master-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "master_admin" {
  role       = aws_iam_role.master_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_instance_profile" "master_profile" {
  name = "wanderlust-master-profile"
  role = aws_iam_role.master_role.name
}


# ----------------------------------------------------------------------------
#JENKINS WORKER ROLE---------------------------------
# --------------------------------------------------------------------------

resource "aws_iam_role" "jenkins_worker_role" {
  name = "wanderlust-jenkins-worker-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "jenkins_worker_admin" {
  role       = aws_iam_role.jenkins_worker_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_instance_profile" "jenkins_worker_profile" {
  name = "wanderlust-jenkins-worker-profile"
  role = aws_iam_role.jenkins_worker_role.name
}
