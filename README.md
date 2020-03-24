# flutter_wya

![GitHub set up](https://github.com/wya-team/flutter_wya/blob/master/image.png)

### Git packages


Sometimes you live on the bleeding edge and need to use packages that haven’t been formally released yet. Maybe your package itself is still in development and is using other packages that are being developed at the same time. To make that easier, you can depend directly on a package stored in a Git repository.

```
dependencies:
  kittens:
    git: git://github.com/munificent/kittens.git
```

The git here says this package is found using Git, and the URL after that is the Git URL that can be used to clone the package.

Even if the package repo is private, if you can connect to the repo using SSH, then you can depend on the package by using the repo’s SSH URL:

```
dependencies:
  kittens:
    git: git@github.com:munificent/kittens.git
```

If you want to depend on a specific commit, branch, or tag, add a ref argument:

```
dependencies:
  kittens:
    git:
      url: git://github.com/munificent/kittens.git
      ref: some-branch
```

The ref can be anything that Git allows to identify a commit.

Pub assumes that the package is in the root of the Git repository. To specify a different location in the repo, use the path argument:

```
dependencies:
  kittens:
    git:
      url: git://github.com/munificent/cats.git
      path: path/to/kittens
 ```

The path is relative to the Git repo’s root.

