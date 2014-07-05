#  Rake And Rails

A couple of years ago, I received an email from a friend stating he was
learning Rails and he thought I should try it out. Although I had a good
programming background, my web development skills were terrible. I knew a bit
of HTML and CSS, but if you had asked me what POST and PUT had in common, I
would have told you they both started with a P and ended with a T. An author
suggested that mastering Rails required bacheloring all aspects of web
development, but the idea of learning everything from scratch did not excite
me. Then, a few days later, I stumbled upon some Ruby syntax on a Pastebin
application online. I had no experience with Ruby, whatsoever, but its syntax
and style were so elegant and expressive that I could easily perceive what the
author of the code was attempting to do. I started toying around with Ruby
books and instantly fell in love with the programming language. That's the
story of my affair with Ruby.

I know what you're wondering-"What does this have to do with Rake and Rails?
And why did I stylize the word scratch?"

Frankly speaking, I hate starting things from scratch. I don't know whether
it's just me or if it's a worldwide phenomenon. When you do something for the
first time, it's called an adventure. If you decide to do it again, and
everyone says it adds to your experience. But on the third run, it turns out
to be boring.

When you step into the Ruby on Rails world as a developer, freelancer or
hobbyist, you will immediately feel the thrill and excitement of getting
started and running

    rails new webapp

But before you sink your teeth into engineering the stunning designs and
concepts of your new web app, there are a series of necessary, although
seemingly trivial details that must be taken care of. Things like cleaning up
the Gemfile, initializing a git repository, setting up gems for your toolkits
like Bootstrap, and configuring guard + spark etc. These steps will, of
course, be beneficial for you as you develop your project, but they loom
before you like a major obstacle to getting started. And in any case, dealing
with these trifles drains all the excitement and energy from me and send me
running for a cup of coffee.

That's one part of the script where Rake makes an appearance. As you may guess
from its name, Rake is a Make-inspired application written in Ruby and
developed by Jim Weirich. Rake is a task management utility that can do
anything from automatically deleting your browser history to building
artificial intelligence. I'm just kidding; Rake can't quite do that, but it is
powerful. Designed to build executable programs from source files, it can do
so much more!

Initially, Jim wasn't convinced that Rake would be useful, but the Ruby
community were happy to prove him wrong by incorporating it with Ruby's
standard library.

> Ok, let me state from the beginning that I never intended to write this
code. I'm not convinced it is useful, and I'm not convinced anyone would even
be interested in it. All I can say is that Why's onion truck must by been
passing through the Ohio valley. What am I talking about? … A Ruby version of
Make.
>
>--Jim Weirich

  

##  Getting started with Rake

  

Rake is an Embedded Domain Specific Language because beyond the walls of ruby,
it has no existence. The term EDSL suggests that Rake is a domain-specific
language that is embedded inside another language (Ruby) which has greater
scope. Rake extends Ruby in that you can use all the features and extensions
that come with Ruby. You could take advantage of Rake by using it to automate
some tasks that have been continually challenging you. Because of this, you
will find the novelty of using it will not quickly wear off and you could find
that you soon become much more productive.

Sounds interesting? Let's get started, shall we?

###  The Basics

Here are a few rake tasks that you are probably used to.

    $ rake db:migrate

    $ rake db:test:prepare

Running rake from the command-line involves calling rake followed by the name
of the task. As the number of tasks increases, maintaining them and creating
new ones becomes quite a tedious task in itself. rake lets you organise your
tasks using namespace and this feature makes it possible to create multiple
tasks having the same name assigned to different namespaces to avoid naming
collision and ambiguity.

For instance, you could create two tasks with the name cleanup.

  1. main:cleanup - This task cleans up your webapp directory removing deadwood files and unnecessary code chunks.
  2. temp:cleanup - This wipes out all the files and folders listed under temp directory. 
Here is a barebones structure of a rake task. ![](image1.png "Getting started with rake")

It consists of

  * A namespace block
  * A short description about the task
  * The name of the task (note that I've used a symbol rather than a string) and a subsequent do..end block
  * The code that the task is supposed to execute
Every piece of code that goes in between task :cleanup do..end block gets
executed when you call

    rake main:cleanup

If you ever decide to add another task under the main namespace, it should be
enclosed inside the outer do..end block. And you can add any number of tasks
under a namespace as long as it sounds logical to do so.

  
  

###  Dependency vs invoke

  

An essential component of any build tool is looking for dependencies (a.k.a
prerequisites) and resolving them. A task can have multiple prerequisites
which ought to get executed prior to the main task.

/home/mj/Rails/Rakefile

    task :default => :third_task 

    task :first_task do
        puts "First task"
    end

    task :second_task do
        puts ">>Second task"
    end

    task :third_task => [:first_task, :second_task] do
        puts ">>>>Hurray. This is the third task"    
        puts " This task depends on the first_task and second_task and won’t be executed unless both the dependencies are satisfied."
        print "The syntax for declaring dependency is "
        puts " :main_task => :dependency"
        puts "and if there are more than 1 dependency, place all the dependencies inside the [] separated by commas "
        puts ":main_task => [:dep1, :dep2]"
    end

If you are wondering what :default is doing up there, it is a Ruby symbol that
bears a special meaning to rake. Running rake without any parameters from the
terminal would execute the third_task by default, because we've declared it
with a :default symbol.

    $ rake

Having prerequisites is useful, but wouldn't it be awesome if we could do it
the conventional, straightforward way. ie calling a task from another task?
You can achieve this without having to leave rake's idioms.

/home/mj/Rails/Rakefile

    namespace :main do
        task :test do
            if true
                puts "Calling test2 task."
	            Rake::Task["main:test2"].invoke #invokes main:test2
	        else
	            abort()
	        end
        end
        task :test2 do
            puts ">Test2 task invoked"
        end
    end

As exemplified above, you can even place the task invocation under a
conditional statement in which case it will be executed only if the condition
falls true.

###  Parameterized Tasks

What if we wanted to, say, pass parameters to our rake task? Sounds
impossible? Not really.

/home/mj/Rails/Rakefile

    task :tests, [:arg1, :arg2] do |t, args|
        puts "First argument: #{ args[:arg1] }"
        puts "Second argument: #{args[:arg2]}"
    end

And the output,

    $ rake tests[1,some_random_string]

    First argument: 1

    Second argument: some_random_string

That's wicked, isn't it? The parameters will go inside the [ ], separated by
commas. And it takes 2 block variables, t and args, where t is the object
concerned with this task and args is a hash that stores your arguments.

Create a test directory for the sake of this example.

    mkdir testapp && cd testapp

We'll create an empty data file and a Rakefile inside testapp and see what
sort of wizardry rake is capable of.

    $ ls
    data.dat Rakefile

/home/mj/Rails/testapp/Rakefile

    namespace :setup do
            desc "A test task to check whether a directory exists"
        task :check do    
            puts "Enter the name of the destination directory: "
            @dir = STDIN.gets.strip  #Calling gets by itself would result in a call to "Kernel#gets" which is not what we want.    
        
            if  File.directory?("../#{@dir}") #Checks whether the user requested directory exists and if not creates a new one.
                puts "The directory exists"
                setup_copy #Calls setup_copy method
            else
                puts "Creating the requested directory..."
                mkdir "../#{@dir}"
                setup_copy
            end
        end
    
        desc "A test task to copy things around"
        task :copy => :check do #A task dependency

            puts "Copying files..."
            cp_r '.', "../#{@dir}" 
            puts "Done.! :)"
        end

    end    

    def setup_copy
        Rake::Task["setup:copy"].invoke #A task invocation
    end

For instant gratification, try running

    rake setup:copy

from the testapp directory. rake performs as it is told.

  1. When setup:copy gets called, rake attempts to satisfy its dependency setup:check. 
  2. The setup:check captures the name of the destination directory through an instance variable. Using a local variable in that instance would mean that it's scope would be restricted to that specific task. However, making it available to the subsequent child tasks would save us a lot of code and time.
  3. The if-else block checks whether the directory already exists, creates one if the condition fails and pokes the setup_copy function. This goes to demonstrate rake's complaisance with ruby. 
  4. The control returns to setup:copy. cp_r method copies all the files residing in the current directory and places them in the user requested folder. (The r in cp_r takes care of copying files recursively so that nothing is left out.) 

Note: I am not sure whether or not you noticed, but we did not require any
standard library file or load any extension to make cp_r and mkdir accessible
in our Rakefile. That's because, fileutils library is loaded with the rakefile
by default. I would highly recommend going through the [ruby docs on
fileutils](http://www.ruby-
doc.org/stdlib-2.0/libdoc/fileutils/rdoc/FileUtils.html). You will definitely
find it useful at some stage of the tutorial.

Wouldn't a task invocation and a dependency result in a conflict of interest?
I thought you might ask something along those lines, so here goes my answer.

No. They can survive together without beating each other up. We'll stick with
employing tasks as prerequisites, that way we can keep the code apparent and
palpable. But, you can do it the other way around too.

Imagine that you have about 4 tasks as depicted in the snippet below.

/home/mj/Rails/Rakefile
    
    namespace :setup do
        task :init do
		    puts ">init: Task to initiate a process"
		    puts ">Imagine that all other tasks depend on this task"
	    end
	    task :cleanup => :init do #This task depends on :init
		    puts ">>cleanup:Tasks related to cleaning up Gemfile, deleting public/index.html etc."
	    end

	    task :git=> :init do #This one too depends on :init
		    puts ">>>git: Tasks concerned with setting up GIT repository"
	    end


	    task :all => [ :init, :cleanup, :git ] do #Depends on init, cleanup and git tasks.
		    puts ">>>>all: Done"

	    end
    end

Try running

    rake setup:all

and see how it works out.

The last-mentioned command executes all the tasks in succession because we've
filled in that task with 3 prerequisites, namely :init, :cleanup and :git.
That's cool. But what if we wanted to set up our GIT repo without cleaning up
our Gemfile?

That too is achievable. Go ahead and type this into your terminal.

    rake setup:git

Since the setup:init is a prerequisite for the task concerned with creation of
a git repo, it will get executed and woohoo.

    Initializing..

    Tasks concerned with setting up GIT repository.

  

##  Rake and Rails: The perfect duo

  

We are nearly done with hiking through the basics of rake. But there are just
a few tiny bits remaining to be discussed about the design of the script we
are about to construct.

Usually, developers tend to have a directory dedicated to Rails inside of
which they create new projects and maintain existing ones. Somewhat like the
screenshot depicted below.

![](image2.png)

That's good. We will create a folder named Rake under the ~/Rails directory
which, in my opinion, is the desirable location to place our Rakefile and all
of the associated files.

    $ cd ~/Rails

    $ mkdir Rake && cd Rake

This grants us the privilege and flexibility to easily access the web
application that needs to be taken care of. Confused, eh? An example might
clear things up.

Create a new Rails application, say, testapp under ~/Rails. (Using the rails
new command)

    $ ls

    testapp Rake

Our Rake directory and Rails application directory are in the same level. So,
let's get started.

The rakefile and all the associated files will dwell inside the Rake
directory. And at the other end we have a testapp directory, which is the
destination directory that we plan to manipulate. The setup:init task will
initiate the process; ie, it will copy all the files residing in Rake
directory to the destination directory's lib/tasks folder. Every Rails app,
generated via the generate script, comes equipped with a lib/tasks folder. The
Rails convention is to place all the rake tasks in this directory, and these
tasks will be accessible from the root of the Rails application directory by
default. In layman's terms, you could place all your rake files (*.rake) in
lib/tasks and then call them up from the root of your application's directory.
Rake will load them without any fuss.

![](image3.jpg)

Here is a sketch of an improved :init task.

/home/mj/Rails/Rake/Rakefile
    
    namespace :setup do 
        desc "Initiate setup. This task serves as a dependency for other tasks."
        task :init do
            print "Name of the destination directory: "
            name = STDIN.gets.strip  
            if pwd().split('/').last == "Rake"     
                puts "Copying the files to #{name}/lib/tasks."
                cp_r '.', "../#{name}/lib/tasks", verbose: false #Copying the rakefile over to lib/tasks of the destination directory. This is a Rails generated directory dedicated for rake tasks.

                print "Do you want to continue with the setup?(y/n): "
                option = STDIN.gets.strip
    
                case option 
               
                when /[^Yy]/
                    abort_message #A call to the abort_message method.  
                end 
                cd "../#{name}" #change directory to the root of the Rails application directory
            end           
        end

        def abort_message
            abort("Exiting. You can each task individually. See rake -T for more info") #A handy method to exit early from a rake task. You can read more about it here.
        end 
    end

Apart from a few ruby constructs, you shouldn't have much trouble decoding it.
Although preserving rake files in lib/tasks isn't mandatory, it might become
advantageous at a later stage of the development phase, when you need to run a
rake task or two. But there is a catch. If you plan to call up the custom rake
tasks from the testapp directory (assuming that it was the destination
directory) as demonstrated below, it wouldn't work.

    $ cd testapp
    rake setup:init

  
    rake aborted!
    Don't know how to build task 'setup:inits'

Although you can call up the tasks from the Rake directory without stumbling
into any issues, executing custom rake tasks from the web application's root
directory as shown will result in an error. This is because rake will ignore
all the files currently placed in lib/tasks, including Rakefile, because it
will only load files having the .rake extension . To fix this, we might have
to tweak our Rakefile. For the moment, we will let this pass and deal with it
later.

Next, we have the cleanup task. You can engineer this task to perform all
sorts of pesky cleanup jobs that you would like to take care of, prior to
getting started with the actual development of the app. As in the case of most
developers, the first thing I do is edit my Gemfile, removing the commented
lines of code, and adding gems without which I find it hard to survive,
resorting to the latest and most stable version of gems etc.

/home/mj/Rails/Rake/Rakefile

    desc "Cleanup Gemfile and other stuff."
    task :cleanup => :init do
        
        print "Clean up the standard Gemfile for a new one?(y/n): "
        option = STDIN.gets.strip
      
        case option 
               
               when /[^Yy]/
                 abort_message
        end
          
        puts "Setting a new Gemfile."
        cp 'lib/tasks/Gemfile', '.', verbose: false #Copying the gemfile from lib/tasks to the root of the project directory.

        puts "Running bundle install. This may take a while...\n\n"
        sh "bundle install" #sh bridges your task with the command-line, bestowing upon you the access to all the terminal commands.

    end

And here is an edited version of the Gemfile.

/home/mj/Rails/Rake/Gemfile

    source 'https://rubygems.org'
    ruby '2.0.0'


    gem 'rails', '4.0.0'

    group :development, :test do
        #development_test
    gem 'sqlite3', '1.3.7'
    end

    group :test do
	    #tests
    end

    gem 'sass-rails', '4.0.0'
    gem 'uglifier', '2.1.1'
    gem 'coffee-rails', '4.0.0'
    gem 'jquery-rails', '2.2.1'
    gem 'turbolinks', '1.1.1'
    gem 'jbuilder', '1.0.2'

    group :doc do
        gem 'sdoc', '0.3.20', require: false
    end
    
    group :production do
	    #production
    end

We'll place the good looking Gemfile in our ~/Rails/Rake directory and rake
will take care of the rest. The command rake setup:init will copy the Gemfile
(along with the Rakefile) to lib/tasks and :cleanup will move it to the root
directory replacing the original Gemfile.

Here is my implementation of tasks concerned with the initialization of git,
creation of git repo and pushing the app into the github repository.

/home/mj/Rails/Rake/Rakefile

    desc "Git tasks"
        task :git => :init do

            print "Create a new GIT repository?(y/n): "
            option = STDIN.gets.strip
          
            case option
               
               when /[^Yy]/
                 abort_message
            end 
          
            sh 'git init'
            puts "Adding a few items to .gitignore."
            cp 'lib/tasks/.gitignore', '.', verbose: false

            puts "Setting up git"
            sh 'git add .'
            sh 'git commit -m "Init" '

            puts "Enter the link to your repository for this app." 
            repo = STDIN.gets.strip
            sh "git remote add origin #{repo}"
            sh 'git push -u origin master'
            
            
    end
Since you have all the terminal commands at your disposal via the [sh
method](http://rake.rubyforge.org/classes/FileUtils.html), you can write a
task to create a git branch with ease.

/home/mj/Rails/Rake/Rakefile

    desc "Create a git branch"
    task :git_branch => :git do
        puts "Creating a git branch, just to be safe!"
        sh 'git checkout -b Pre-development'
    end

    desc "Run all setup tasks"
    task :all => [:init, :cleanup, :git, :git_branch] do
        puts "DOne"
    end	

This is how our barebone tasks from snippet 1.05 would look if a bit of meat
was added to them.

/home/mj/Rails/Rake/Rakefile

    namespace :setup do 
        desc "Initiate setup. This task serves as a dependency for other tasks."
        task :init do
            print "Name of the destination directory: "
            name = STDIN.gets.strip  
            #Calling gets by itself would result in a call to Kernel#gets which is not what we want. Switch to STDIN.gets instead. 
            if pwd().split('/').last == "Rake"    
                puts "Copying the files to #{name}/lib/tasks."
                cp_r '.', "../#{name}/lib/tasks", verbose: false #Copying the rakefile over to lib/tasks of the destination directory. This is a Rails generated directory dedicated for rake tasks.

                print "Do you want to continue with the setup?(y/n): "
                option = STDIN.gets.strip
    
                   case option 
               
                   when /[^Yy]/
                     abort_message #A call to the abort_message method.  
                   end 
                cd "../#{name}" #change directory to the root of the Rails app directory
            end        
        end

	    def abort_message
        	abort("Exiting. You can each task individually. See rake -T for more info") #A handy method to exit early from a rake task. You can read more about it here.
	    end 


        desc "Cleanup Gemfile and other stuff."
        task :cleanup => :init do
        
            print "Clean up the standard Gemfile for a new one?(y/n): "
            option = STDIN.gets.strip
      
            case option 
               
            when /[^Yy]/
            abort_message
            end
          
            puts "Setting a new Gemfile."
            cp 'lib/tasks/Gemfile', '.', verbose: false #Copying the gemfile from lib/tasks to the root of the project directory.

            puts "Running bundle install. This may take a while...\n\n"
            sh "bundle install" #sh bridges your task with the command-line bestowing upon you, the access to all the terminal commands.

        end


        desc "Git tasks"
        task :git => :init do

            print "Create a new GIT repository?(y/n): "
            option = STDIN.gets.strip
          
            case option
               
               when /[^Yy]/
                 abort_message
            end 
          
            sh 'git init'
            puts "Adding a few items to .gitignore."
            cp 'lib/tasks/.gitignore', '.', verbose: false

            puts "Setting up git"
            sh 'git add .'
            sh 'git commit -m "Init" '

            puts "Enter the link to your repository for this app." 
            repo = STDIN.gets.strip
            sh "git remote add origin #{repo}"
            sh 'git push -u origin master'
            
            
        end

        desc "Task to create a new git branch"
        task :git_branch => :git do
            puts "Creating a git branch, just to be safe!"
            sh 'git checkout -b Pre-development'

        end
    
        desc "Task to run all tasks under the setup namespace"
        task :all => [:init, :cleanup, :git, :git_branch] do
            puts "DOne"
        end	
    end

That's a lot of code, but it's fairly easy to figure out what it does, because
ruby doesn't complicate matters, but rather streamlines it to the point where
a total stranger to ruby can make sense out of it.

  

## Don't forget to DRY your code

  

The Rakefile looks a bit cluttered to me. Since it's going to get pretty bad
soon, we should refactor it and clean it up a bit. The ideal solution would be
to keep the tasks neatly sorted into rake files and import them to the main
Rakefile.

/home/mj/Rails/Rake/Rakefile

    Dir.glob('*.rake').each { |r| import r }

  

/home/mj/Rails/Rake/init.rake

    namespace :setup do 
        desc "Initiate setup. This task serves as a dependency for other tasks."
	    task :init do
		    print "Name of the destination directory: "
		    name = STDIN.gets.strip 
		    if pwd().split('/').last == "Rake"	
			    puts "Copying the files to #{name}/lib/tasks."
			    cp_r '.', "../#{name}/lib/tasks", verbose: false

			    print "Do you want to continue with the setup?(y/n): "
			    option = STDIN.gets.strip
	
	   		    case_code(option)
				    cd "../#{name}"
		    else 
			    puts "We are already on the destination directory"
		    end		
        end
 

	    def abort_message
		    abort("Exiting. You can each task individually. See rake -T for more info")
    	end 

	
	    def case_code(option)
		    case option
	   		
	   		when /[^Yy]/
     			abort_message
	   	    end 
	    end
    end

/home/mj/Rails/Rake/cleanup.rake

    namespace :setup do

        desc "Cleanup Gemfile and other stuff."
	    task :cleanup => :init do
		
	        print "Clean up the standard Gemfile for a new one?(y/n): "
	        option = STDIN.gets.strip
	  
	        case_code(option)
	  	
	  	   	    puts "Setting a new Gemfile."
	  		    cp 'lib/tasks/Gemfile', '.', verbose: false

	  		    puts "Running bundle install. This may take a while...\n\n"
	  		    sh "bundle install"

        	end
    end
  

/home/mj/Rails/Rake/git.rake

    namespace :setup do
    
	    desc "Git tasks"
	    task :git => :init do

		    print "Create a new GIT repository?(y/n): "
		    option = STDIN.gets.strip
	  	
	  	    case_code(option)
	  	
				sh 'git init'
				puts "Adding a few items to .gitignore."
				cp 'lib/tasks/.gitignore', '.', verbose: false

				puts "Setting up git"
				sh 'git add .'
				sh 'git commit -m "Init" '

				puts "Enter the link to your repository for this app." 
				repo = STDIN.gets.strip
				sh "git remote add origin #{repo}"
				sh 'git push -u origin master'
			
			
	    end

	    task :git_branch => :git do
		    puts "Creating a git branch, just to be safe!"
		    sh 'git checkout -b Pre-development'

		
	    end
	   
	   	

    end

  

/home/mj/Rails/Rake/all.rake

    namespace :setup do     
	    task :all => [:init, :cleanup, :git, :git_branch] do
			puts "DOne"
	    end	
    end

This benefits us in 2 ways,

  1. Our rake tasks are now organized and easily accessible.
  2. You can call up these tasks at any stage of web development from the project's root directory. If you will recall, I had mentioned that the files residing in lib/tasks will only be loaded if they have a .rake extension. Rake ignored our custom rake tasks earlier because we had stored them inside the Rakefile.

Rake can automate tons of tasks, which you thought were too trivial or too
complex. This tutorial was written with the intention to get you started with
rake to make your life easier by doing things with less human intervention.
And now that you've felt rake in action, you shouldn't have trouble widening
your horizons and making the best use of it.

