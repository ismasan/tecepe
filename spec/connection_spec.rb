require File.dirname(__FILE__) + '/spec_helper'

describe Tecepe::Connection do
  
  def message(args)
    "#{JSON.generate(args)}\n"
  end
  
  describe "#receive_data" do
    
    before do
      @test_klass = Class.new do
        include Tecepe::Connection
        
        attr_reader :replies
        
        def send_data raw_data
          (@replies ||= []) << JSON.parse(raw_data)
        end
        
        def error?
          false
        end
      end
      
      @connection = @test_klass.new
    end
    
    after do
      Tecepe.clear_handlers
    end
    
    it "triggers event callbacks" do
      Tecepe.on 'test1' do |json|
        json['name'].should == 'ismael'
      end
      @connection.receive_data message(event: 'test1', payload: {name: 'ismael'})
    end
    
    it "replies in event callbacks" do
      Tecepe.on 'test1' do |json|
        reply message: "event received!", by: json['name']
      end
      @connection.receive_data message(event: 'test1', payload: {name: 'ismael'})
      @connection.replies.last['status'].should == 1
      @connection.replies.last['payload']['message'].should == 'event received!'
      @connection.replies.last['payload']['by'].should == 'ismael'
    end
    
    it 'waits for line breaks to parse messages' do
      Tecepe.on 'test1' do |json|
        reply message: "event received!", pong: json['message']
      end
      @connection.receive_data '{"event":"test1"'
      @connection.receive_data ',"payload":{"message":"hola!"}'
      @connection.receive_data "}\n"
      
      @connection.replies.last['payload']['message'].should == 'event received!'
      @connection.replies.last['status'].should == 1
      @connection.replies.last['payload']['pong'].should == 'hola!'
    end
    
    it 'replies with error if no handler found' do
      @connection.receive_data message(event: 'foo', payload: {name: 'ismael'})
      @connection.replies.last['status'].should == -1
      @connection.replies.last['payload']['message'].should == 'No handler for event foo'
    end
  end
end