require 'guard/compat/test/helper'

require 'guard/annotate'

RSpec.describe Guard::Annotate do
  subject { Guard::Annotate.new }

  before do
    allow(Guard::Compat::UI).to receive(:info)
    allow(Guard::Compat::UI).to receive(:notify)
  end

  context "#initialize options" do
    describe "notify" do
      it "should be true by default" do
        expect(subject.send(:notify?)).to be(true)
      end

      it "should allow notifications to be turned off" do
        subject = Guard::Annotate.new(:notify => false)
        expect(subject.options[:notify]).to be_falsey
      end
    end

    describe "position" do
      it "should use 'before' position by default" do
        expect(subject.options[:position]).to eq('before')
      end

      it "should allow user to customize position (before)" do
        subject = Guard::Annotate.new(:position => 'before')
        expect(subject.options[:position]).to eq('before')
        expect(subject).to receive(:system).with("bundle exec annotate --exclude tests,fixtures -p before")
        subject.start
      end

      it "should allow user to customize position (after)" do
        subject = Guard::Annotate.new(:position => 'after')
        expect(subject.options[:position]).to eq('after')
        expect(subject).to receive(:system).with("bundle exec annotate --exclude tests,fixtures -p after")
        subject.start
      end
    end

    describe "routes" do
      it "should not run routes by default" do
        expect(subject.options[:routes]).to be_falsey
      end

      it "should allow the users to run routes if desired" do
        subject = Guard::Annotate.new(:routes => true)
        expect(subject).to receive(:system).with("bundle exec annotate --exclude tests,fixtures -p before")
        expect(subject).to receive(:system).with("bundle exec annotate -r -p before")
        subject.start
      end

      it "should allow the user to customize routes annotation position (before)" do
        subject = Guard::Annotate.new(:routes => true, :position => 'before')
        expect(subject).to receive(:system).with("bundle exec annotate --exclude tests,fixtures -p before")
        expect(subject).to receive(:system).with("bundle exec annotate -r -p before")
        subject.start
      end

      it "should allow the user to customize routes annotation position (after)" do
        subject = Guard::Annotate.new(:routes => true, :position => 'after')
        expect(subject).to receive(:system).with("bundle exec annotate --exclude tests,fixtures -p after")
        expect(subject).to receive(:system).with("bundle exec annotate -r -p after")
        subject.start
      end
    end

    describe "tests & fixtures" do
      it "should not run tests annotations by default" do
        expect(subject.options[:tests]).to be_falsey
      end

      it "should allow user to run tests and fixtures annotations if desired" do
        subject = Guard::Annotate.new(:tests => true)
        expect(subject).to receive(:system).with("bundle exec annotate  -p before")
        subject.start
      end
    end

    describe "factories" do
      it "should run factories annotations by default" do
        expect(subject.options[:factories]).to be_truthy
      end

      it "should allow user to exclude factories annotations if desired" do
        subject = Guard::Annotate.new(:factories => false)
        expect(subject).to receive(:system).with("bundle exec annotate --exclude tests,fixtures,factories -p before")
        subject.start
      end
    end

    describe "serializers" do
      it "should run serializers annotations by default" do
        expect(subject.options[:serializers]).to be_truthy
      end

      it "should allow user to exclude serializers annotations if desired" do
        subject = Guard::Annotate.new(:serializers => false)
        expect(subject).to receive(:system).with("bundle exec annotate --exclude tests,fixtures,serializers -p before")
        subject.start
      end
    end

    describe "sort columns by name" do
      it "should not sort columns by name by default" do
        expect(subject.options[:sort]).to be_falsey
      end

      it "should allow user to sort columns by name if desired" do
        subject = Guard::Annotate.new(:sort => true)
        expect(subject).to receive(:system).with("bundle exec annotate --exclude tests,fixtures -p before --sort")
        subject.start
      end
    end

    describe "indexes" do
      it "should not add indexes to annotations by default" do
        expect(subject.options[:show_indexes]).to be_falsey
      end

      it "should allow user to add indexes to annotations if desired" do
        subject = Guard::Annotate.new(:show_indexes => true)
        expect(subject).to receive(:system).with("bundle exec annotate --exclude tests,fixtures -p before --show-indexes")
        subject.start
      end
    end

    describe "simple indexes" do
      it "should not add simple indexes to annotations by default" do
        expect(subject.options[:simple_indexes]).to be_falsey
      end

      it "should allow user to add simple indexes to annotations if desired" do
        subject = Guard::Annotate.new(:simple_indexes => true)
        expect(subject).to receive(:system).with("bundle exec annotate --exclude tests,fixtures -p before --simple-indexes")
        subject.start
      end
    end

    describe "foreign keys" do
      it "should not add foreign keys to annotations by default" do
        expect(subject.options[:show_foreign_keys]).to be_falsey
      end

      it "should allow user to add foreign keys to annotations if desired" do
        subject = Guard::Annotate.new(:show_foreign_keys => true)
        expect(subject).to receive(:system).with("bundle exec annotate --exclude tests,fixtures -p before --show-foreign-keys")
        subject.start
      end
    end

    describe "show migration" do
      it "should not show migration version in annotations by default" do
        expect(subject.options[:show_migration]).to be_falsey
      end

      it "should allow user to add migration version in annotations if desired" do
        subject = Guard::Annotate.new(:show_migration => true)
        expect(subject).to receive(:system).with("bundle exec annotate --exclude tests,fixtures -p before --show-migration")
        subject.start
      end
    end

    describe "annotation format" do
      it "should not add format type to annotations by default" do
        expect(subject.options[:show_migration]).to be_falsey
      end

      describe "invalid" do
        it "should not add format type if option given is invalid" do
          subject = Guard::Annotate.new(:format => :invalid_option)
          expect(subject.options[:show_migration]).to be_falsey
          expect(subject).to receive(:system).with("bundle exec annotate --exclude tests,fixtures -p before")
          subject.start
        end
      end
      describe "bare" do
        it "should allow user to choose format of annotations if desired" do
          subject = Guard::Annotate.new(:format => :bare)
          expect(subject).to receive(:system).with("bundle exec annotate --exclude tests,fixtures -p before --format=bare")
          subject.start
        end
      end
      describe "rdoc" do
        it "should allow user to choose format of annotations if desired" do
          subject = Guard::Annotate.new(:format => :rdoc)
          expect(subject).to receive(:system).with("bundle exec annotate --exclude tests,fixtures -p before --format=rdoc")
          subject.start
        end
      end
      describe "markdown" do
        it "should allow user to choose format of annotations if desired" do
          subject = Guard::Annotate.new(:format => :markdown)
          expect(subject).to receive(:system).with("bundle exec annotate --exclude tests,fixtures -p before --format=markdown")
          subject.start
        end
      end
    end

    describe "run_at_start" do
      it "should run at start by default" do
        expect(subject.options[:run_at_start]).to be_truthy
      end

      it "should allow user to opt out of running at start" do
        subject = Guard::Annotate.new(:run_at_start => false)
        expect(subject.options[:run_at_start]).to be_falsey
      end
    end
  end

  context "start" do
    it "should run annotate command" do
      expect(subject).to receive(:system).with("bundle exec annotate --exclude tests,fixtures -p before")
      subject.start
    end

    it "should return false if annotate command fails" do
      expect(subject).to receive(:system).with("bundle exec annotate --exclude tests,fixtures -p before").and_return(false)
      expect(subject.start).to be_falsey
    end

    it 'should not run annotate command if disabled :run_at_start' do
      expect(subject).not_to receive(:system)
      subject.options[:run_at_start] = false
      subject.start
    end
  end

  context "stop" do
    it "should be a noop (return true)" do
      expect(subject.stop).to be_truthy
    end
  end

  context "reload" do
    it "should run annotate command" do
      expect(subject).to receive(:system).with("bundle exec annotate --exclude tests,fixtures -p before")
      subject.reload
    end

    it "should return false if annotate command fails" do
      expect(subject).to receive(:system).with("bundle exec annotate --exclude tests,fixtures -p before").and_return(false)
      expect(subject.reload).to be_falsey
    end

    it 'should not run annotate command if disabled :run_at_start' do
      expect(subject).not_to receive(:system)
      subject.options[:run_at_start] = false
      subject.reload
    end
  end

  context "run_all" do
    it "should be a noop (return true)" do
      expect(subject.run_all).to be_truthy
    end
  end

  # For Guard 1.1. #run_on_change is deprecated
  context "run_on_changes" do
    it "should run annotate command" do
      expect(subject).to receive(:system).with("bundle exec annotate --exclude tests,fixtures -p before")
      subject.run_on_changes
    end

    it "should return false if annotate command fails" do
      expect(subject).to receive(:system).with("bundle exec annotate --exclude tests,fixtures -p before").and_return(false)
      expect(subject.run_on_changes).to be_falsey
    end
  end
end
