require 'rails_helper'

RSpec.describe WithdrawPossibilitiesService do
  subject do
    described_class.new(amount)
  end

  let(:amount) { 250.0 }

  describe '#call' do
    context 'quando o valor é maior ou igual a 20' do
      it 'deve possuir duas possibilidades de saque' do
        possibilities = subject.call

        expect(possibilities.size).to eq(2)
      end

      it 'nenhuma das possibilidades deve possuir 0 notas de 2, 20 ou 50' do
        possibilities = subject.call

        expect(possibilities.flat_map(&:values)).not_to include(0)
      end
    end

    context 'quando o valor é menor que 20' do
      let(:amount) { 18.0 }

      it 'deve possuir somente uma possibilidade de saque' do
        possibilities = subject.call

        expect(possibilities.size).to eq(1)
      end

      it 'a possibilidade não deve possuir 0 notas de 2, 20 ou 50' do
        possibility = subject.call

        expect(possibility.flat_map(&:values)).not_to include(0)
      end
    end
  end

  describe '.call' do
    it 'inicia o serviço, executa e retorna o resultado de #call' do
      service = instance_double('WithdrawPossibilitiesService')
      hash = instance_double(Hash)

      expect(described_class).to receive(:new).with(amount).once.and_return(service)
      expect(service).to receive(:call).and_return(hash)

      expect(described_class.call(amount)).to eq(hash)
    end
  end
end
