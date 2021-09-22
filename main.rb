# frozen_string_literal: true

require 'bundler/inline'
require 'bigdecimal'

gemfile do
  source 'https://rubygems.org'
  gem 'pry'
end

Percent = ->(x) { x / d(100) }

AnualMensal = lambda { |taxa_anual|
  (d(1) + taxa_anual)**(d(1) / d(12)) - d(1)
}

def d(input)
  BigDecimal(input.to_s)
end

def final_calc(recurrence, args = {})
  return final_calc_mensal(**args) if mensal?(recurrence)

  final_calc_anual(**args)
end

def final_calc_anual(valor_inicial:, quantidade_de_anos:, aporte_mensal:, percentual_anual:)
  valor_final = valor_inicial
  quantidade_de_anos.times do
    valor_final =
      ((valor_final + (aporte_mensal * d(12))) * (d(1) + Percent.call(percentual_anual)))
  end
  valor_final
end

def final_calc_mensal(valor_inicial:, quantidade_de_anos:, aporte_mensal:, percentual_anual:)
  valor_final = valor_inicial
  meses = quantidade_de_anos * 12
  meses.times do
    valor_final =
      ((valor_final + aporte_mensal) * (d(1) + AnualMensal.call(Percent.call(percentual_anual))))
  end
  valor_final
end

def valor_inicial
  puts 'Digite o valor inicial: '
  d(gets.chomp)
end

def quantidade_de_anos
  puts 'Digite a quantidade de anos: '
  gets.chomp.to_i
end

def aporte_mensal
  puts 'Digite o valor aplicado mensalmente: '
  d(gets.chomp)
end

def percentual_anual
  puts 'Digite o percentual de ganho anual: '
  d(gets.chomp)
end

def final_message(input)
  puts "M: R$ #{final_calc('s', input).round}"
  puts "A: R$ #{final_calc('n', input).round}"
end

def manual
  input = {
    valor_inicial: valor_inicial,
    quantidade_de_anos: quantidade_de_anos,
    aporte_mensal: aporte_mensal,
    percentual_anual: percentual_anual
  }
  final_message(input)
end

def automatic
  input = {
    valor_inicial: d(0),
    quantidade_de_anos: 30,
    aporte_mensal: d(5000),
    percentual_anual: d(6.5)
  }
  final_message(input)
end

def mensal?(input)
  %w[S s].include?(input)
end

def main
  puts 'Digitar o valor manual?(s/n) '
  result = gets.chomp

  return manual if %w[S s].include?(result)

  automatic
end

main
