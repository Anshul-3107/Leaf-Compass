import React, { useState, useRef, useEffect } from 'react';
import axios from 'axios';
import './Chatpage.css'; // We will create this next
// import { FaRobot, FaUser, FaPaperPlane } from 'react-icons/fa';


const ChatPage = () => {
  const [messages, setMessages] = useState([
    { text: "Hello! 🌾 I am your AgroAI expert. Ask me about crop diseases, fertilizer recommendations, or yield estimates.", sender: "bot" }
  ]);
  const [input, setInput] = useState("");
  const [loading, setLoading] = useState(false);
  
  const messagesEndRef = useRef(null);

  const scrollToBottom = () => {
    messagesEndRef.current?.scrollIntoView({ behavior: "smooth" });
  };

  useEffect(() => {
    scrollToBottom();
  }, [messages]);

  const sendMessage = async (e) => {
    e.preventDefault();
    if (!input.trim()) return;

    const userMessage = { text: input, sender: "user" };
    setMessages((prev) => [...prev, userMessage]);
    setInput("");
    setLoading(true);

    try {
      const response = await axios.post("http://localhost:8000/chat", { message: input });
      const botMessage = { text: response.data.response, sender: "bot" };
      setMessages((prev) => [...prev, botMessage]);
    } catch (error) {
      setMessages((prev) => [...prev, { text: "Error: Could not connect to AI server.", sender: "bot" }]);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="chat-page-container">
      <div className="chat-history">
        {messages.map((msg, index) => (
          <div key={index} className={`chat-bubble ${msg.sender}`}>
            <div className="bubble-content">{msg.text}</div>
          </div>
        ))}
        {loading && <div className="chat-bubble bot"><div className="bubble-content">Thinking...</div></div>}
        <div ref={messagesEndRef} />
      </div>

      <form className="chat-input-area" onSubmit={sendMessage}>
        <div><input 
          type="text" 
          placeholder="Ask about your crops..." 
          value={input}
          onChange={(e) => setInput(e.target.value)} 
        /></div>
        <button type="submit">Send</button>
      </form>
    </div>
  );
};

export default ChatPage;