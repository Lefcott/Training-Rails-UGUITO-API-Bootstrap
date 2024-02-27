require 'rails_helper'

RSpec.describe Note, type: :model do
  subject(:note) { create(:note, utility: north_utility) }

  let(:north_utility) { create(:north_utility, code: 1) }
  let(:south_utility) { create(:south_utility, code: 1) }

  %i[title content type].each do |value|
    it { is_expected.to validate_presence_of(value) }
  end

  it { is_expected.to have_one(:utility).through(:user) }

  it 'has a valid factory' do
    expect(subject).to be_valid
  end

  describe '#word_count' do
    it 'returns the correct number of words' do
      subject.content = 'it has four words'
      expect(subject.word_count).to equal 4
    end
  end

  describe 'NorthUtility' do
    let(:short_content_length) { 50 }
    let(:medium_content_length) { 100 }

    describe '#content_length' do
      subject(:note) { create(:note, type: :critique, utility: north_utility, content: content) }

      context 'when content has less than 50 words' do
        let(:content) { 'word ' * (short_content_length - 1) }

        it 'returns short' do
          expect(subject.content_length).to eq 'short'
        end
      end

      context 'when content has 50 words' do
        let(:content) { 'word ' * short_content_length }

        it 'returns short' do
          expect(subject.content_length).to eq 'short'
        end
      end

      context 'when content has less than 100 words' do
        let(:content) { 'word ' * (medium_content_length - 1) }

        it 'returns medium' do
          expect(subject.content_length).to eq 'medium'
        end
      end

      context 'when content has 100 words' do
        let(:content) { 'word ' * medium_content_length }

        it 'returns medium' do
          expect(subject.content_length).to eq 'medium'
        end
      end

      context 'when content has more than 100 words' do
        let(:content) { 'word ' * (medium_content_length + 1) }

        it 'returns long' do
          expect(subject.content_length).to eq 'long'
        end
      end
    end

    describe '#validate_word_count' do
      describe 'for note with type: review' do
        subject(:note) { build(:note, type: :review, utility: north_utility, content: content) }

        context 'when count is less than 50' do
          let(:content) { 'word ' * (short_content_length - 1) }

          it 'succeeds' do
            expect { subject.save! }.not_to raise_error
          end
        end

        context 'when word count is 50' do
          let(:content) { 'word ' * short_content_length }

          it 'succeeds' do
            expect { subject.save! }.not_to raise_error
          end
        end

        context 'when word count is greater than 50' do
          let(:content) { 'word ' * (short_content_length + 1) }

          it 'fails' do
            expect { subject.save! }.to raise_error(ActiveRecord::RecordInvalid, /#{Regexp.escape(I18n.t('note.word_count_validation', max_words: short_content_length))}/)
          end
        end
      end

      describe 'for note with type: critique' do
        subject(:note) { build(:note, type: :critique, utility: north_utility, content: content) }

        context 'when word count is less than 50' do
          let(:content) { 'word ' * (short_content_length - 1) }

          it 'succeeds' do
            expect { subject.save! }.not_to raise_error
          end
        end

        context 'when word count is 50' do
          let(:content) { 'word ' * short_content_length }

          it 'succeeds' do
            expect { subject.save! }.not_to raise_error
          end
        end

        context 'when word count is greater than 50' do
          let(:content) { 'word ' * (short_content_length + 1) }

          it 'succeeds' do
            expect { subject.save! }.not_to raise_error
          end
        end
      end
    end
  end

  describe 'SouthUtility' do
    let(:short_content_length) { 60 }
    let(:medium_content_length) { 120 }

    describe '#content_length' do
      subject(:note) { create(:note, type: :critique, utility: south_utility, content: content) }

      context 'when content has less than 60 words' do
        let(:content) { 'word ' * (short_content_length - 1) }

        it 'returns short' do
          expect(subject.content_length).to eq 'short'
        end
      end

      context 'when content has 60 words' do
        let(:content) { 'word ' * short_content_length }

        it 'returns short' do
          expect(subject.content_length).to eq 'short'
        end
      end

      context 'when content has less than 120 words' do
        let(:content) { 'word ' * (medium_content_length - 1) }

        it 'returns medium' do
          expect(subject.content_length).to eq 'medium'
        end
      end

      context 'when content has 120 words' do
        let(:content) { 'word ' * medium_content_length }

        it 'returns medium' do
          expect(subject.content_length).to eq 'medium'
        end
      end

      context 'when content has more than 120 words' do
        let(:content) { 'word ' * (medium_content_length + 1) }

        it 'returns long' do
          expect(subject.content_length).to eq 'long'
        end
      end
    end

    describe '#validate_word_count' do
      describe 'for note with type: review' do
        subject(:note) { build(:note, type: :review, utility: south_utility, content: content) }

        context 'when count is less than 60' do
          let(:content) { 'word ' * (short_content_length - 1) }

          it 'succeeds' do
            expect { subject.save! }.not_to raise_error
          end
        end

        context 'when word count is 60' do
          let(:content) { 'word ' * short_content_length }

          it 'succeeds' do
            expect { subject.save! }.not_to raise_error
          end
        end

        context 'when word count is greater than 60' do
          let(:content) { 'word ' * (short_content_length + 1) }

          it 'fails' do
            expect { subject.save! }.to raise_error(ActiveRecord::RecordInvalid, /#{Regexp.escape(I18n.t('note.word_count_validation', max_words: short_content_length))}/)
          end
        end
      end

      describe 'for note with type: critique' do
        subject(:note) { build(:note, type: :critique, utility: north_utility, content: content) }

        context 'when word count is less than 60' do
          let(:content) { 'word ' * (short_content_length - 1) }

          it 'succeeds' do
            expect { subject.save! }.not_to raise_error
          end
        end

        context 'when word count is 60' do
          let(:content) { 'word ' * short_content_length }

          it 'succeeds' do
            expect { subject.save! }.not_to raise_error
          end
        end

        context 'when word count is greater than 60' do
          let(:content) { 'word ' * (short_content_length + 1) }

          it 'succeeds' do
            expect { subject.save! }.not_to raise_error
          end
        end
      end
    end
  end
end
